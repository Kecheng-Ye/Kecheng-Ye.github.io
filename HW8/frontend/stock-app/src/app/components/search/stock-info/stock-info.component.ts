import { Component, OnInit, ViewEncapsulation, ChangeDetectorRef, AfterContentChecked} from '@angular/core';
import { StockQueryService } from '../../../services/stock-query.service';
import { state } from '../../../util';

@Component({
  selector: 'app-stock-info',
  templateUrl: './stock-info.component.html',
  styleUrls: ['./stock-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockInfoComponent implements OnInit {
  search_state: state = state.PENDING;
  state = state;

  constructor(private stock_query: StockQueryService, private cdref: ChangeDetectorRef) {
  }

  ngOnInit(): void {
    this.stock_query.get_search_state().subscribe((new_state) => {
      this.search_state = new_state;
    });
  }

  ngAfterContentChecked() {
    this.cdref.detectChanges();
  }
}
