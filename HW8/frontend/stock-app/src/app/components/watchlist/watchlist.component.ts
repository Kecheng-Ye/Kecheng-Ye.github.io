import { Component, HostListener, OnInit, ViewEncapsulation } from "@angular/core";
import { StockQueryService } from '../../services/stock-query.service';
import { MyProfileService } from '../../services/my-profile.service';
import { concatMap, forkJoin, of, take } from "rxjs";
import { single_watch_info } from '../../data_interface/watchlist';

@Component({
  selector: 'app-watchlist',
  templateUrl: './watchlist.component.html',
  styleUrls: ['./watchlist.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
  providers: [MyProfileService],
})
export class WatchlistComponent implements OnInit {
  watch_list_result: single_watch_info[] = [];
  is_ready: boolean = false;
  is_empty: boolean = false;

  constructor(
    private stock_query: StockQueryService,
    private my_profile_query: MyProfileService
  ) {}

  ngOnInit(): void {
    this.my_profile_query
      .watchlist$
      .pipe(
        take(1),
        concatMap((new_list) => {
          return this.do_joined_query([...new_list.keys()]);
        }),
      )
      .subscribe(this.retrieve_joined_query);
  }

  do_joined_query = (watch_key_list: string[]) => {
    this.is_ready = false;
    if(watch_key_list.length == 0) {
      return of([]);
    }

    let query_lst = [];

    for (const ticker of watch_key_list) {
      query_lst.push(
        forkJoin([
          this.stock_query.get_brief(ticker),
          this.stock_query.get_cur_price(ticker),
        ])
      );
    }

    return forkJoin(query_lst);
  };

  retrieve_joined_query = (result_query: any) => {
    let index = 0;
    for (const one_query of result_query) {
      const [brief, price] = one_query;
      this.watch_list_result.push({ ...brief, ...price, index: index++ });
    }

    this.is_empty = result_query.length == 0;
    this.is_ready = true;
  };

  delete_stock(stock_idx: number) {
    const stock_to_remove = this.watch_list_result[stock_idx];
    this.my_profile_query.remove_from_watchlist(stock_to_remove.ticker);
    this.watch_list_result.splice(stock_to_remove.index, 1);
  }

  @HostListener('window:beforeunload', ['$event'])
  unload(event: any) {
    this.my_profile_query.update_local_all();
  }
}
