import { Component, OnInit, OnDestroy,ViewEncapsulation } from '@angular/core';
import { stock_main_info } from '../../data_interface/stock_main_info';
import * as moment from 'moment';
import { second, state } from '../../util';
import { forkJoin, of, Subscription, switchMap, timer } from 'rxjs';
import { StockQueryService } from '../../services/stock-query.service';
import { SearchUpdateService } from '../../services/search-update.service';
import { PreviousStateService } from "../../services/previous-state.service";

const TIME_INTERVAL = 1000 * second;

@Component({
  selector: 'app-stock-main-info',
  templateUrl: './stock-main-info.component.html',
  styleUrls: ['./stock-main-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockMainInfoComponent implements OnInit, OnDestroy{
  ticker: string = '';
  main_info_data: stock_main_info = {} as stock_main_info;
  subscription: Subscription = new Subscription();
  market_time: moment.Moment = moment();
  moment = moment;
  cur_state: state = state.PENDING;
  state = state;

  constructor(
    private stock_query: StockQueryService,
    private ticker_query: SearchUpdateService,
    private prev_info_query: PreviousStateService
  ) {}

  ngOnInit(): void {
    this.ticker_query.fetch_ticker()
      .pipe(
        switchMap(([ticker, ticker_change]) => {
          this.ticker = ticker;
          if (ticker_change) {
            return this.do_joined_query();
          } else {
            return this.prev_info_query.get_prev_main_info();
          }
        })
      )
      .subscribe(this.retrieve_data, this.handel_err, () => {});

    this.subscription = timer(TIME_INTERVAL, TIME_INTERVAL)
      .pipe(switchMap(this.fetch_live_price))
      .subscribe(this.update_live_price, this.handel_err, () => {});

    this.stock_query.get_search_state().subscribe((new_state) => {
      this.cur_state = new_state;
    });
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
  }

  is_market_open(): boolean {
    const cur = moment();
    return cur < this.market_time;
  }

  do_joined_query = () => {
    this.stock_query.update_search_state(state.PENDING);
    const query_list = {
      brief: this.stock_query.get_brief(this.ticker),
      cur_price: this.stock_query.get_cur_price(this.ticker),
    };

    return forkJoin(query_list);
  };

  retrieve_data = (result: any) => {
    if(result.hasOwnProperty("market_time"))  {
      this.main_info_data = result;
    }else{
      this.retrieve_joined_query(result);
    }
  }

  retrieve_joined_query = (result_dct: any) => {
    this.main_info_data = {} as stock_main_info;
    this.stock_query.update_search_state(state.SUCCESS);
    this.stock_query.update_market_time(result_dct.cur_price.t);
    this.market_time = moment.unix(result_dct.cur_price.t);
    this.main_info_data = {
      name: { ...result_dct.brief },
      img: result_dct.brief.logo,
      price: { ...result_dct.cur_price },
      is_market_open: this.is_market_open(),
      market_time: this.market_time.format('YYYY-MM-DD HH:mm:ss'),
    };

    this.prev_info_query.update_main_info(this.main_info_data);
  };

  handel_err = (err: any) => {
    this.stock_query.update_search_state(state.FAIL);
    this.subscription.unsubscribe();
  };

  fetch_live_price = () => {
    return this.stock_query.get_cur_price(this.ticker);
  };

  update_live_price = (result: any) => {
    this.stock_query.update_market_time(result.t);
    this.market_time = moment.unix(result.t);
    this.main_info_data.price = { ...result };
    this.main_info_data.is_market_open = this.is_market_open();
    this.main_info_data.market_time = this.market_time.format(
      'YYYY-MM-DD HH:mm:ss'
    );
  };


}
