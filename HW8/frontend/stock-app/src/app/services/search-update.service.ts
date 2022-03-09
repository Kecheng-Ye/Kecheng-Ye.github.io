import { Injectable } from '@angular/core';
import { Observable, Subject } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class SearchUpdateService {
  private is_home_page: boolean = false;
  private is_home_page_subject:Subject<boolean> = new Subject<boolean>();
  private previous_ticker: string = "";
  private previous_ticker_subject:Subject<string> = new Subject<string>();

  constructor() { }

  update_search(is_home: boolean, cur_ticker: string): void {
    this.is_home_page = is_home;
    this.is_home_page_subject.next(this.is_home_page);
    
    this.previous_ticker = (this.is_home_page) ? "" : cur_ticker;
    this.previous_ticker_subject.next(this.previous_ticker);
  }

  get_search_state(): Observable<boolean> {
    return this.is_home_page_subject.asObservable();
  }

  fetch_prev_ticker(): Observable<string> {
    return this.previous_ticker_subject.asObservable();
  }
}
