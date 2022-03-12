import { Component, OnInit, Input, ViewEncapsulation } from '@angular/core';
import { StockQueryService } from '../../services/stock-query.service';
import { forkJoin, of, Subscription, switchMap, timer } from 'rxjs';
import { stock_main_info } from '../../data_interface/stock_main_info';
import { ActivatedRoute } from '@angular/router';

const TIME_INTERVAL = 15000;

@Component({
  selector: 'app-stock-info',
  templateUrl: './stock-info.component.html',
  styleUrls: ['./stock-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockInfoComponent implements OnInit {
  @Input() ticker: string = '';
  main_info: stock_main_info = {} as stock_main_info;
  subscription: Subscription = new Subscription();
  cur_ticker: string = '';

  constructor(
    private stock_query: StockQueryService,
    private activatedRoute: ActivatedRoute
  ) {}

  do_joined_query = () => {
    // const query_list = {
    //   brief: this.stock_query.get_brief(this.cur_ticker),
    //   price: this.stock_query.get_price(this.cur_ticker),
    // };
    //
    // return forkJoin(query_list);

    return of({
      brief: {
        country: 'US',
        currency: 'USD',
        exchange: 'NASDAQ NMS - GLOBAL MARKET',
        finnhubIndustry: 'Technology',
        ipo: '1980-12-12',
        logo: 'https://finnhub.io/api/logo?symbol=AAPL',
        marketCapitalization: 2586958,
        name: 'Apple Inc',
        phone: '14089961010.0',
        shareOutstanding: 16319.44,
        ticker: 'AAPL',
        weburl: 'https://www.apple.com/',
      },
      price: {
        c: 154.73,
        d: -3.79,
        dp: -2.3909,
        h: 159.2799,
        l: 154.5,
        o: 158.93,
        pc: 158.52,
        t: 1647032403,
      },
    });
  };

  retrieve_joined_query = (result_dct: any) => {
    this.main_info = {
      ...result_dct.brief,
      ...result_dct.price,
    } as stock_main_info;
  };

  ngOnInit(): void {
    // Timer for auto update
    this.subscription = timer(0, TIME_INTERVAL)
      .pipe(switchMap(this.do_joined_query))
      .subscribe(this.retrieve_joined_query);

    // update for change route
    this.activatedRoute.paramMap.subscribe((params) => {
      let new_ticker = params.get('ticker');
      if (new_ticker == null) return;

      this.cur_ticker = new_ticker.toUpperCase();
    });
  }
}
