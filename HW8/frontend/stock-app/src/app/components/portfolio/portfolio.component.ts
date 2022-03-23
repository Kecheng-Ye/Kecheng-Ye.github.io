import {
  Component,
  HostListener,
  OnDestroy,
  OnInit,
  ViewEncapsulation,
} from '@angular/core';
import {
  one_portfolio_entry,
  transaction,
} from '../../data_interface/portfolio';
import { MyProfileService } from '../../services/my-profile.service';
import { forkJoin, of, Subscription, switchMap, take } from 'rxjs';
import { StockQueryService } from '../../services/stock-query.service';
import { BuyingModalComponent } from './buying-modal/buying-modal.component';
import { round, second } from '../../util';
import { SellingModalComponent } from './selling-modal/selling-modal.component';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'app-portfolio',
  templateUrl: './portfolio.component.html',
  styleUrls: ['./portfolio.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
  providers: [MyProfileService],
})
export class PortfolioComponent implements OnInit, OnDestroy {
  is_ready = true;
  is_empty = false;
  portfolio_list: Map<string, [number, transaction[]]> = new Map();
  balance: number = 0;
  subscription: Subscription = new Subscription();
  transaction_rec_list: one_portfolio_entry[] = [];
  buy_notice = false;
  sell_notice = false;
  target_ticker: string = '';

  constructor(
    private my_profile_query: MyProfileService,
    private stock_query: StockQueryService,
    private modalService: NgbModal
  ) {}

  ngOnInit(): void {
    this.subscription = forkJoin([
      this.my_profile_query.all_transactions$.pipe(take(1)),
      this.my_profile_query.balance$.pipe(take(1)),
    ])
      .pipe(
        switchMap(([new_portfolio, new_balance]) => {
          this.portfolio_list = new Map<string, [number, transaction[]]>(
            new_portfolio
          );
          this.balance = new_balance;
          this.is_empty = this.portfolio_list.size == 0;
          return this.joined_query();
        })
      )
      .subscribe(this.retrieve_joined_query);
  }

  joined_query = () => {
    this.is_ready = false;
    if (this.portfolio_list.size == 0) {
      return of([]);
    }

    let query_lst = {};

    this.portfolio_list.forEach((_, ticker) => {
      // @ts-ignore
      query_lst[ticker] = forkJoin([
        this.stock_query.get_brief(ticker),
        this.stock_query.get_cur_price(ticker),
      ]);
    });

    return forkJoin(query_lst);
  };

  retrieve_joined_query = (result_query: any) => {
    let idx = 0;
    for (const [ticker, val] of Object.entries(result_query)) {
      // @ts-ignore
      const [brief, price] = val;
      let new_rec = {
        ...brief,
        ...price,
        record: this.portfolio_list.get(ticker)!,
        index: idx++,
      } as one_portfolio_entry;
      this.calculate_cost_data(new_rec);
      this.transaction_rec_list.push(new_rec);
    }

    console.log(this.transaction_rec_list);
    this.is_ready = true;
  };

  calculate_cost_data(data: one_portfolio_entry) {
    data.total_cost = 0;
    for (const transaction of data.record[1]) {
      data.total_cost += transaction.price * transaction.shares;
    }

    data.total_cost = round(data.total_cost, 2);
    data.avg_cost = round(data.total_cost / data.record[0], 2);
    data.change = round(data.c - data.avg_cost, 2);
    data.market_val = round(data.c * data.record[0], 2);
    data.color = data.change > 0 ? 'green' : data.change < 0 ? 'red' : 'black';
  }

  open_buy_modal(index: number) {
    const buy_modal = this.modalService.open(BuyingModalComponent);
    buy_modal.componentInstance.data = {
      name: this.transaction_rec_list[index].name,
      price: this.transaction_rec_list[index].c,
    };
    buy_modal.componentInstance.balance = this.balance;
    buy_modal.componentInstance.buy_event.subscribe((result: transaction) => {
      this.my_profile_query
        .buy_stock(this.transaction_rec_list[index].ticker, result)
        .subscribe((result) => {
          this.buy_operation_successful(result, index);
        });
    });
  }

  buy_operation_successful(result: any, index: number) {
    const [new_balance, new_rec] = result;
    this.balance = new_balance;
    this.transaction_rec_list[index].record = new_rec;
    this.calculate_cost_data(this.transaction_rec_list[index]);
    this.buy_notice = true;
    this.target_ticker = this.transaction_rec_list[index].ticker;
    setTimeout(() => this.close_buy_notice(), 5 * second);
  }

  close_buy_notice() {
    this.target_ticker = '';
    this.buy_notice = false;
  }

  open_sell_modal(index: number) {
    const sell_modal = this.modalService.open(SellingModalComponent);
    sell_modal.componentInstance.data = {
      name: this.transaction_rec_list[index].name,
      price: this.transaction_rec_list[index].c,
      shares_remain: this.transaction_rec_list[index].record[0],
    };
    sell_modal.componentInstance.balance = this.balance;
    sell_modal.componentInstance.sell_event.subscribe((result: transaction) => {
      this.my_profile_query
        .sell_stock(this.transaction_rec_list[index].ticker, result)
        .subscribe((result) => {
          this.sell_operation_successful(result, index);
        });
    });
  }

  sell_operation_successful(result: any, index: number) {
    const [new_balance, new_rec] = result;
    this.target_ticker = this.transaction_rec_list[index].ticker;
    this.balance = new_balance;
    if (new_rec[0] == 0) {
      this.transaction_rec_list.splice(index, 1);
      this.is_empty = this.transaction_rec_list.length == 0;
    } else {
      this.transaction_rec_list[index].record = new_rec;
      this.calculate_cost_data(this.transaction_rec_list[index]);
    }
    this.sell_notice = true;
    setTimeout(() => this.close_sell_notice(), 5 * second);
  }

  close_sell_notice() {
    this.target_ticker = '';
    this.sell_notice = false;
  }

  ngOnDestroy(): void {
    this.subscription.unsubscribe();
  }

  @HostListener('window:beforeunload', ['$event'])
  unload(event: any) {
    this.my_profile_query.update_local_all();
  }
}
