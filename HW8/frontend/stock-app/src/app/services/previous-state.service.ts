import { Injectable } from '@angular/core';
import { BehaviorSubject } from "rxjs";
import * as moment from "moment";
import { stock_main_info } from "../data_interface/stock_main_info";
import { Insights_Info, News, Summary_Info } from "../data_interface/stock_sub_info";

@Injectable({
  providedIn: 'root'
})
export class PreviousStateService {
  private prev_main_info = new BehaviorSubject({} as stock_main_info);
  private prev_summary_info = new BehaviorSubject({} as Summary_Info);
  private prev_news = new BehaviorSubject([] as News[]);
  private prev_historical_record = new BehaviorSubject([[], []] as [number[][], number[][]]);
  private prev_insights_info = new BehaviorSubject({} as Insights_Info);

  constructor() { }

  update_main_info(new_info: stock_main_info) {
    this.prev_main_info.next(new_info);
  }

  get_prev_main_info() {
    return this.prev_main_info.asObservable();
  }

  update_historical_record(new_rec: [number[][], number[][]]) {
    this.prev_historical_record.next(new_rec);
  }

  get_prev_historical_record() {
    return this.prev_historical_record.asObservable();
  }

  update_summary_info(new_summary: Summary_Info) {
    this.prev_summary_info.next(new_summary);
  }

  get_prev_summary_info() {
    return this.prev_summary_info.asObservable();
  }

  update_news_list(new_news_lst: News[]) {
    this.prev_news.next(new_news_lst);
  }

  get_prev_news_list() {
    return this.prev_news.asObservable();
  }

  update_insights_info(new_insights: Insights_Info) {
    this.prev_insights_info.next(new_insights);
  }

  get_insights_info() {
    return this.prev_insights_info.asObservable();
  }
}
