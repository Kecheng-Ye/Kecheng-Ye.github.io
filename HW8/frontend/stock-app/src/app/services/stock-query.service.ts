import { Injectable } from '@angular/core';
import {Observable, of} from "rxjs";
import { HttpClient } from '@angular/common/http';
import {Suggestion_query} from "../data_interface/suggestion";

@Injectable({
  providedIn: 'root'
})
export class StockQueryService {
  api_url: string = "/api";

  constructor(private http: HttpClient) { }

  getBrief(ticker: string): Observable<Object> {
    return this.http.get<Object>(this.api_url + '/brief/' + ticker);
  }

  get_autocomplete_suggestion(stock_name: string): Observable<Suggestion_query> {
    console.log("Query for ", stock_name);
    return this.http.get<Suggestion_query>(this.api_url + '/autocomplete/' + stock_name);
  }
}
