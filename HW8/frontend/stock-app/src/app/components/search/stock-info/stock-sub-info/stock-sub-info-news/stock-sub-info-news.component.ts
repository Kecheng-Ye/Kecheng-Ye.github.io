import { Component, OnInit } from '@angular/core';
import { StockQueryService } from '../../../../../services/stock-query.service';
import { SearchUpdateService } from '../../../../../services/search-update.service';
import { News } from '../../../../../data_interface/stock_sub_info';
import { trime } from '../../../../../util';
import { of, switchMap } from 'rxjs';
import { PreviousStateService } from '../../../../../services/previous-state.service';

@Component({
  selector: 'app-stock-sub-info-news',
  templateUrl: './stock-sub-info-news.component.html',
  styleUrls: ['./stock-sub-info-news.component.css'],
})
export class StockSubInfoNewsComponent implements OnInit {
  ticker: string = '';
  valid_news: News[] = [];
  is_loading = true;

  constructor(
    private stock_query: StockQueryService,
    private ticker_query: SearchUpdateService,
    private prev_info_query: PreviousStateService
  ) {}

  joined_query_list = () => {
    this.is_loading = true;
    return this.stock_query.get_latest_news(this.ticker);
  };

  retrieve_data = (result: any) => {
    if(result[0].hasOwnProperty('trim_header')) {
      this.valid_news = result;
    }else{
      this.retrieve_query(result);
    }

    this.is_loading = false;
  };

  retrieve_query = (new_news_lst: News[]) => {
    this.valid_news = [];
    let count = 0;
    for (let i = 0; i < new_news_lst.length && count < 5; i++) {
      let one_news = new_news_lst[i];
      let success = true;

      for (const [key, value] of Object.entries(one_news)) {
        if (value == null || value.length == 0) {
          success = false;
          break;
        }
      }

      if (success) {
        this.valid_news.push(one_news);
        count++;
      }
    }

    this.prev_info_query.update_news_list(this.valid_news);
  }

  ngOnInit(): void {
    this.ticker_query
      .fetch_ticker()
      .pipe(
        switchMap(([ticker, ticker_change]) => {
          this.ticker = ticker;
          if (ticker_change) {
            return this.joined_query_list();
          } else {
            return this.prev_info_query.get_prev_news_list();
          }
        })
      )
      .subscribe(this.retrieve_data);
  }
}
