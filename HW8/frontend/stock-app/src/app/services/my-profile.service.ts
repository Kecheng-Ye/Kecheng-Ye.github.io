import { HostListener, Injectable, OnDestroy } from '@angular/core';
import { BehaviorSubject, from, Observable, of, timer } from 'rxjs';
import { transaction } from '../data_interface/portfolio';
import { round, second, TIME_INTERVAL } from '../util';

const START_BALANCE = 25000;

@Injectable({
  providedIn: 'root',
})
export class MyProfileService implements OnDestroy {
  // watch list
  private WATCH_LIST_KEY: string = '_watch_list';
  private _watch_list: Map<string, number> = new Map();
  get watch_list(): ReadonlyMap<string, number> {
    return this._watch_list;
  }
  private _watch_list_observe: BehaviorSubject<ReadonlyMap<string, number>> =
    new BehaviorSubject<ReadonlyMap<string, number>>(this.watch_list);
  get watchlist$(): Observable<ReadonlyMap<string, number>> {
    return this._watch_list_observe.asObservable();
  }
  notify_watch_list() {
    this._watch_list_observe.next(this.watch_list);
  }

  //  portfolio list
  private PORTFOLIO_LIST_KEY: string = '_portfolio_list';
  private _portfolio_list: Map<string, [number, transaction[]]> = new Map();
  get portfolio_list(): ReadonlyMap<string, [number, transaction[]]> {
    return this._portfolio_list;
  }
  private _portfolio_list_observe: BehaviorSubject<
    ReadonlyMap<string, [number, transaction[]]>
  > = new BehaviorSubject<ReadonlyMap<string, [number, transaction[]]>>(
    this.portfolio_list
  );
  get all_transactions$(): Observable<
    ReadonlyMap<string, [number, transaction[]]>
  > {
    return this._portfolio_list_observe.asObservable();
  }
  notify_portfolio_list() {
    this._portfolio_list_observe.next(this.portfolio_list);
  }

  // balance
  private BALANCE_KEY: string = '_balance';
  private _balance: number = START_BALANCE;
  get balance(): Readonly<number> {
    return this._balance;
  }
  private _balance_observe: BehaviorSubject<Readonly<number>> =
    new BehaviorSubject<Readonly<number>>(this.balance);
  get balance$(): Observable<Readonly<number>> {
    return this._balance_observe.asObservable();
  }
  notify_balance() {
    this._balance_observe.next(this.balance);
  }

  constructor() {
    this.init_data_from_storage(this.WATCH_LIST_KEY);
    this.init_data_from_storage(this.PORTFOLIO_LIST_KEY);
    this.init_data_from_storage(this.BALANCE_KEY);
    this.notify_all();
  }

  notify_all() {
    this.notify_watch_list();
    this.notify_portfolio_list();
    this.notify_balance();
  }

  replacer(key: any, value: any) {
    if (value instanceof Map) {
      return {
        dataType: 'Map',
        value: Array.from(value.entries()), // or with spread: value: [...value]
      };
    } else {
      return value;
    }
  }

  reviver(key: any, value: any) {
    if (typeof value === 'object' && value !== null) {
      if (value.dataType === 'Map') {
        return new Map(value.value);
      }
    }
    return value;
  }

  init_data_from_storage = (key: string) => {
    const retrieve_item = localStorage.getItem(key);
    if (!retrieve_item) {
      if (key != this.BALANCE_KEY) {
        // @ts-ignore
        this[key] = new Map();
      } else {
        // @ts-ignore
        this[key] = START_BALANCE;
      }
    } else {
      // @ts-ignore
      this[key] = JSON.parse(retrieve_item, this.reviver);
    }
  };

  update_storage(obj: any, key: string) {
    localStorage.setItem(key, JSON.stringify(obj, this.replacer));
  }

  is_stock_in_watch_list(ticker: string): Observable<boolean> {
    return of(this.watch_list.has(ticker));
  }

  add_to_watchlist(ticker: string): void {
    this._watch_list.set(ticker, 1);
    this.notify_watch_list();
  }

  remove_from_watchlist(ticker: string) {
    this._watch_list.delete(ticker);
    this.notify_watch_list();
  }

  get_stock_transaction_record(
    ticker: string
  ): Observable<[number, transaction[]]> {
    const result = this.portfolio_list.get(ticker);
    if (!result) return of([0, []]);
    return of(result);
  }

  buy_stock(
    ticker: string,
    record: transaction
  ): Observable<[number, [number, transaction[]]]> {
    if (!this.portfolio_list.has(ticker)) {
      this._portfolio_list.set(ticker, [0, []]);
    }

    let one_stock_transaction = this._portfolio_list.get(ticker)!;
    one_stock_transaction[0] += record.shares;
    one_stock_transaction[1].push(record);
    this._balance = round(this.balance - record.price * record.shares, 2);

    this.notify_portfolio_list();
    this.notify_balance();

    return of([this.balance, one_stock_transaction]);
  }

  sell_stock(
    ticker: string,
    trans: transaction
  ): Observable<[number, [number, transaction[]]]> {
    let result = this._portfolio_list.get(ticker)!;
    const price = trans.price,
      shares = trans.shares;
    let [hold_shares, record] = result;

    this._balance = round(this.balance + price * shares, 2);
    if (hold_shares == shares) {
      result = [0, []];
      this._portfolio_list.delete(ticker);
    } else {
      let shares_remain = shares,
        idx = 0;

      for (let one_record of record) {
        if (one_record.shares > shares_remain) {
          one_record.shares -= shares_remain;
          break;
        } else {
          idx++;
          shares_remain -= one_record.shares;
        }
      }

      record.splice(0, idx);
      hold_shares -= shares;
      result = [hold_shares, record];

      this._portfolio_list.set(ticker, result);
    }

    this.notify_portfolio_list();
    this.notify_balance();

    return of([this.balance, result]);
  }

  update_local_all() {
    console.log('local storage write back');
    this.update_storage(this.watch_list, this.WATCH_LIST_KEY);
    this.update_storage(this.portfolio_list, this.PORTFOLIO_LIST_KEY);
    this.update_storage(this.balance, this.BALANCE_KEY);
  }

  ngOnDestroy() {
    this.update_local_all();
  }
}
