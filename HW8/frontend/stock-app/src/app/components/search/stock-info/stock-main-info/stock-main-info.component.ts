import {
  Component,
  OnInit,
  OnDestroy,
  ViewEncapsulation,
  HostListener,
} from '@angular/core';
import { stock_main_info } from '../../../../data_interface/stock_main_info';
import * as moment from 'moment';
import { second, state, TIME_INTERVAL } from '../../../../util';
import { forkJoin, Subscription, switchMap, take, timer } from 'rxjs';
import { StockQueryService } from '../../../../services/stock-query.service';
import { SearchUpdateService } from '../../../../services/search-update.service';
import { PreviousStateService } from '../../../../services/previous-state.service';
import { MyProfileService } from '../../../../services/my-profile.service';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { BuyingModalComponent } from '../../../portfolio/buying-modal/buying-modal.component';
import { transaction } from '../../../../data_interface/portfolio';
import { SellingModalComponent } from '../../../portfolio/selling-modal/selling-modal.component';

@Component({
  selector: 'app-stock-main-info',
  templateUrl: './stock-main-info.component.html',
  styleUrls: ['./stock-main-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
  providers: [MyProfileService],
})
export class StockMainInfoComponent implements OnInit, OnDestroy {
  ticker: string = '';
  main_info_data: stock_main_info = {} as stock_main_info;
  subscription: Subscription = new Subscription();
  first_routine: Subscription = new Subscription();
  market_time: moment.Moment = moment();
  moment = moment;
  state = state;
  cur_state: state = state.PENDING;
  watch_list_notice = false;
  buy_notice = false;
  sell_notice = false;

  constructor(
    private stock_query: StockQueryService,
    private ticker_query: SearchUpdateService,
    private prev_info_query: PreviousStateService,
    private my_profile_query: MyProfileService,
    private modalService: NgbModal
  ) {}

  ngOnInit(): void {
    this.first_routine = this.ticker_query
      .fetch_ticker()
      .pipe(
        switchMap(([ticker, ticker_change]) => {
          this.ticker = ticker;
          if (ticker_change) {
            return this.do_joined_query(true)();
          } else {
            return this.prev_info_query.get_prev_main_info();
          }
        })
      )
      .subscribe(this.retrieve_data, this.handel_err, () => {});

    this.subscription = timer(TIME_INTERVAL, TIME_INTERVAL)
      .pipe(switchMap(this.do_joined_query(false)))
      .subscribe(this.retrieve_data, this.handel_err, () => {});

    this.stock_query.get_search_state().subscribe((new_state) => {
      this.cur_state = new_state;
    });
  }

  is_market_open(): boolean {
    const cur = moment();
    return cur < this.market_time;
  }

  do_joined_query = (need_refresh: boolean) => () => {
    if (need_refresh) this.stock_query.update_search_state(state.PENDING);
    const query_list = {
      brief: this.stock_query.get_brief(this.ticker),
      cur_price: this.stock_query.get_cur_price(this.ticker),
    };

    return forkJoin(query_list);
  };

  retrieve_data = (result: any) => {
    if (result.hasOwnProperty('market_time')) {
      this.main_info_data = result;
    } else {
      this.retrieve_joined_query(result);
    }

    forkJoin({
      watch_list: this.my_profile_query
        .is_stock_in_watch_list(this.ticker)
        .pipe(take(1)),
      transaction_record: this.my_profile_query
        .get_stock_transaction_record(this.ticker)
        .pipe(take(1)),
      balance: this.my_profile_query.balance$.pipe(take(1)).pipe(take(1)),
    })
      .pipe(take(1))
      .subscribe((my_profile) => {
        this.main_info_data.name.is_in_watch_list = my_profile.watch_list;
        this.main_info_data.name.transaction_rec =
          my_profile.transaction_record;
        this.main_info_data.balance = my_profile.balance;
      });

    this.stock_query.update_search_state(state.SUCCESS);
  };

  retrieve_joined_query = (result_dct: any) => {
    this.main_info_data = {} as stock_main_info;
    this.stock_query.update_market_time(result_dct.cur_price.t);
    this.market_time = moment.unix(result_dct.cur_price.t);
    this.main_info_data = {
      name: {
        ...result_dct.brief,
        is_in_watch_list: false,
        transaction_rec: [0, []],
      },
      img: result_dct.brief.logo,
      price: { ...result_dct.cur_price },
      is_market_open: this.is_market_open(),
      market_time: this.market_time.format('YYYY-MM-DD HH:mm:ss'),
      balance: 0,
    };

    this.prev_info_query.update_main_info(this.main_info_data);
  };

  handel_err = (err: any) => {
    this.stock_query.update_search_state(state.FAIL);
    this.subscription.unsubscribe();
  };

  watch_list_change(state: boolean) {
    this.main_info_data.name.is_in_watch_list = state;
    if (state) {
      this.my_profile_query.add_to_watchlist(this.ticker);
    } else {
      this.my_profile_query.remove_from_watchlist(this.ticker);
    }
    this.watch_list_notice = true;
    setTimeout(() => this.close_watch_list_notice(), 5 * second);
  }

  close_watch_list_notice() {
    this.watch_list_notice = false;
  }

  open_buy_modal() {
    const buy_modal = this.modalService.open(BuyingModalComponent);
    buy_modal.componentInstance.data = {
      name: this.main_info_data.name.name,
      price: this.main_info_data.price.c,
    };
    buy_modal.componentInstance.balance = this.main_info_data.balance;
    buy_modal.componentInstance.buy_event.subscribe((result: transaction) => {
      this.my_profile_query
        .buy_stock(this.ticker, result)
        .subscribe((result) => {
          this.buy_operation_successful(result);
        });
    });
  }

  buy_operation_successful(result: any) {
    const [new_balance, new_rec] = result;
    this.main_info_data.balance = new_balance;
    this.main_info_data.name.transaction_rec = new_rec;
    this.buy_notice = true;
    setTimeout(() => this.close_buy_notice(), 5 * second);
  }

  close_buy_notice() {
    this.buy_notice = false;
  }

  open_sell_modal() {
    const cell_modal = this.modalService.open(SellingModalComponent);
    cell_modal.componentInstance.data = {
      name: this.main_info_data.name.name,
      price: this.main_info_data.price.c,
      shares_remain: this.main_info_data.name.transaction_rec[0],
    };
    cell_modal.componentInstance.balance = this.main_info_data.balance;
    cell_modal.componentInstance.sell_event.subscribe((result: transaction) => {
      this.my_profile_query
        .sell_stock(this.ticker, result)
        .subscribe((result) => {
          this.sell_operation_successful(result);
        });
    });
  }

  sell_operation_successful(result: any) {
    const [new_balance, new_rec] = result;
    this.main_info_data.balance = new_balance;
    this.main_info_data.name.transaction_rec = new_rec;
    this.sell_notice = true;
    setTimeout(() => this.close_sell_notice(), 5 * second);
  }

  close_sell_notice() {
    this.sell_notice = false;
  }

  @HostListener('window:beforeunload', ['$event'])
  unload(event: any) {
    this.my_profile_query.update_local_all();
  }

  ngOnDestroy() {
    this.subscription.unsubscribe();
    this.first_routine.unsubscribe();
  }
}
