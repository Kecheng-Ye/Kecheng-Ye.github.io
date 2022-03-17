import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, Subject } from "rxjs";

@Injectable({
  providedIn: 'root'
})
export class SearchUpdateService {
  private is_home_page = new BehaviorSubject(false);
  private cur_ticker = new BehaviorSubject(['', true] as [string, boolean]);

  constructor() { }

  update_search(is_home: boolean, cur_ticker: string): void {
    this.is_home_page.next(is_home);
    const has_change = (cur_ticker != this.cur_ticker.getValue()[0]);
    const new_ticker = ((this.is_home_page.getValue()) ? "" : cur_ticker);
    this.cur_ticker.next([new_ticker, has_change]);
  }

  get_search_state(): Observable<boolean> {
    return this.is_home_page.asObservable();
  }

  fetch_ticker(): Observable<[string, boolean]> {
    return this.cur_ticker.asObservable();
  }
}
