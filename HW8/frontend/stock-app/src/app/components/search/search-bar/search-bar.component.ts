import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { Router } from '@angular/router';
import { StockQueryService } from '../../../services/stock-query.service';
import { Suggestion } from '../../../data_interface/suggestion';
import { FormControl } from '@angular/forms';
import { debounceTime, finalize, Observable, of, switchMap, tap } from 'rxjs';

const MAX_WIDTH = 400;

@Component({
  selector: 'app-search-bar',
  templateUrl: './search-bar.component.html',
  styleUrls: ['./search-bar.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class SearchBarComponent implements OnInit {
  public myControl = new FormControl();
  filteredOptions: Suggestion[] = [];
  public isLoading: boolean = false;
  reload = true;

  constructor(private router: Router, private stock_query: StockQueryService) {}

  ngOnInit() {
    this.myControl.valueChanges
      .pipe(
        debounceTime(500),
        tap(() => {
          this.reload = false;
          this.filteredOptions = [];
          this.isLoading = true;
        }),
        switchMap((prefix) => this.do_prefix_query(prefix))
      )
      .subscribe(
        (suggest_query) =>
          (this.filteredOptions =
            this.reload ? [] : suggest_query.result)
      );
  }

  private do_prefix_query(prefix: string) {
    const final_prefix = prefix.toUpperCase();
    if (final_prefix.length == 0) {
      this.isLoading = false;
      return [];
    }

    return this.stock_query.get_autocomplete_suggestion(final_prefix).pipe(
      finalize(() => {
        this.isLoading = false;
      })
    );
  }

  search_click(): void {
    this.isLoading = false;
    this.filteredOptions = [];
    this.reload = true;
    const target_ticker =
      this.myControl.value.length == 0
        ? 'home'
        : this.myControl.value.toUpperCase();

    this.router.navigateByUrl('/search/' + target_ticker);
  }

  clear_click(): void {
    this.myControl.setValue('');
  }
}
