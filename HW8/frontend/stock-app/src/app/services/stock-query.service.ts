import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, of, Subject } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Suggestion_query } from '../data_interface/suggestion';
import * as moment from 'moment';
import {
  Earning_Info,
  Historical_Record,
  Hourly_Price_Record,
  News,
  Recommend_Info,
  Social_Sentiment_List,
} from '../data_interface/stock_sub_info';
import {
  auto_query,
  brief_query,
  cur_price_query, DEBUG,
  earning_query,
  historical_query,
  hourly_query,
  news_query,
  peers_query,
  recommend_query,
  social_query,
  state
} from "../util";
import { Company_Brief, Cur_Price } from '../data_interface/stock_main_info';

@Injectable({
  providedIn: 'root',
})
export class StockQueryService {
  api_url: string = '/api';
  private market_latest = new BehaviorSubject(moment());
  private search_state = new BehaviorSubject(state.PENDING);
  private color = new BehaviorSubject('black');
  private debug = DEBUG;

  constructor(private http: HttpClient) {}

  get_brief(ticker: string): Observable<Company_Brief> {
    if (this.debug) {
      return of(brief_query);
    }

    return this.http.get<Company_Brief>(this.api_url + '/brief/' + ticker);
  }

  get_cur_price(ticker: string): Observable<Cur_Price> {
    if (this.debug) {
      return of(cur_price_query);
    }

    return this.http.get<Cur_Price>(this.api_url + '/price/' + ticker);
  }

  get_peers(ticker: string): Observable<string[]> {
    if (this.debug) {
      return of(peers_query);
    }
    return this.http.get<string[]>(this.api_url + '/peers/' + ticker);
  }

  update_market_time(timestamp: number) {
    this.market_latest.next(moment.unix(timestamp));
  }

  get_market_time(): Observable<moment.Moment> {
    return this.market_latest.asObservable();
  }

  update_search_state(new_state: state) {
    this.search_state.next(new_state);
  }

  get_search_state(): Observable<state> {
    return this.search_state.asObservable();
  }

  update_color(color: string) {
    this.color.next(color);
  }

  get_color(): Observable<string> {
    return this.color.asObservable();
  }

  get_hourly_record(
    ticker: string,
    time: moment.Moment
  ): Observable<Hourly_Price_Record> {
    if (this.debug) {
      return of(hourly_query);
    }

    return this.http.get<Hourly_Price_Record>(
      this.api_url + '/hour-charts/' + ticker + `?start=${time.format('X')}`
    );
  }

  get_autocomplete_suggestion(
    stock_name: string
  ): Observable<Suggestion_query> {
    if (this.debug) {
      return of(auto_query);
    }

    return this.http.get<Suggestion_query>(
      this.api_url + '/autocomplete/' + stock_name
    );
  }

  get_latest_news(ticker: string): Observable<News[]> {
    if (this.debug) {
      return of(news_query);
    }
    return this.http.get<News[]>(this.api_url + '/news/' + ticker);
  }

  get_historical_record(
    ticker: string,
    time: moment.Moment
  ): Observable<Historical_Record> {
    if (this.debug) {
      return of(historical_query);
    }

    return this.http.get<Historical_Record>(
      this.api_url +
        '/historical-charts/' +
        ticker +
        `?start=${time.format('X')}`
    );
  }

  get_recommend_info_lst(ticker: string): Observable<Recommend_Info[]> {
    if (this.debug) {
      return of(recommend_query);
    }

    return this.http.get<Recommend_Info[]>(
      this.api_url + '/recommend/' + ticker
    );
  }

  get_earning_lst(ticker: string): Observable<Earning_Info[]> {
    if (this.debug) {
      return of(earning_query);
    }

    return this.http.get<Earning_Info[]>(this.api_url + '/earnings/' + ticker);
  }

  get_social_sentiments_lst(ticker: string): Observable<Social_Sentiment_List> {
    if (this.debug) {
      return of(social_query);
    }

    return this.http.get<Social_Sentiment_List>(
      this.api_url + '/social-sentiments/' + ticker
    );
  }
}
