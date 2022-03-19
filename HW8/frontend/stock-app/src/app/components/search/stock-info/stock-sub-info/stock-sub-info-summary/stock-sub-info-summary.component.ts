import { Component, OnInit } from '@angular/core';
import { Summary_Info } from '../../../../../data_interface/stock_sub_info';
import { StockQueryService } from '../../../../../services/stock-query.service';
import {
  concat,
  concatMap,
  delay,
  forkJoin,
  Subscription,
  switchMap,
  take,
  timer,
} from 'rxjs';
import * as moment from 'moment';
import { SearchUpdateService } from '../../../../../services/search-update.service';
import { PreviousStateService } from '../../../../../services/previous-state.service';
import { TIME_INTERVAL } from '../../../../../util';

@Component({
  selector: 'app-stock-sub-info-summary',
  templateUrl: './stock-sub-info-summary.component.html',
  styleUrls: ['./stock-sub-info-summary.component.css'],
})
export class StockSubInfoSummaryComponent implements OnInit {
  ticker: string = '';
  stock_summary_data: Summary_Info = {} as Summary_Info;
  market_time: moment.Moment = moment();
  is_loading = true;
  subscription: Subscription = new Subscription();
  color: string = 'black';

  constructor(
    private stock_query: StockQueryService,
    private ticker_query: SearchUpdateService,
    private prev_info_query: PreviousStateService
  ) {}

  joined_query_list = (need_fresh: boolean) => () => {
    this.is_loading = need_fresh;
    const query_list = {
      // get brief info from main info data
      main_info: this.prev_info_query.get_prev_main_info().pipe(take(1)),
      peers: this.stock_query.get_peers(this.ticker),
      hourly_record: this.stock_query.get_hourly_record(
        this.ticker,
        this.market_time
      ),
    };

    return forkJoin(query_list);
  };

  retrieve_data = (result: any) => {
    if (result.hasOwnProperty('about')) {
      this.stock_summary_data = result;
    } else {
      this.retrieve_query(result);
    }

    this.color =
      this.stock_summary_data.price_info.d > 0
        ? 'green'
        : this.stock_summary_data.price_info.d < 0
        ? 'red'
        : 'black';
    this.is_loading = false;
  };

  retrieve_query = (result_dict: any) => {
    this.stock_summary_data = {
      price_info: result_dict.main_info.price,
      about: { ...result_dict.main_info.name, peers: result_dict.peers },
      hourly_record: result_dict.hourly_record,
    };

    this.prev_info_query.update_summary_info(this.stock_summary_data);
  };

  ngOnInit(): void {
    forkJoin([
      this.stock_query.get_market_time().pipe(take(1)),
      this.ticker_query.fetch_ticker().pipe(take(1)),
    ])
      .pipe(
        concatMap(([new_time, [ticker, ticker_change]]) => {
          this.market_time = new_time;
          this.ticker = ticker;
          if (ticker_change) {
            return this.joined_query_list(true)();
          } else {
            return this.prev_info_query.get_prev_summary_info();
          }
        })
      )
      .subscribe(this.retrieve_data);

    const _timer = timer(TIME_INTERVAL, TIME_INTERVAL);

    this.subscription = _timer
      .pipe(
        concatMap(() => {
          return this.stock_query.get_market_time().pipe(
            concatMap((new_time) => {
              this.market_time = new_time;
              return this.joined_query_list(false)();
            })
          );
        })
      )
      .subscribe(this.retrieve_data);
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }
}
