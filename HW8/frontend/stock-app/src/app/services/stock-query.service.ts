import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { HttpClient } from '@angular/common/http';
import { Suggestion_query } from '../data_interface/suggestion';

@Injectable({
  providedIn: 'root',
})
export class StockQueryService {
  api_url: string = '/api';

  constructor(private http: HttpClient) {}

  get_brief(ticker: string): Observable<Object> {
    return this.http.get<Object>(this.api_url + '/brief/' + ticker);
  }

  get_price(ticker: string): Observable<Object> {
    return this.http.get<Object>(this.api_url + '/price/' + ticker);
  }

  get_autocomplete_suggestion(
    stock_name: string
  ): Observable<Suggestion_query> {
    // return this.http.get<Suggestion_query>(
    //   this.api_url + '/autocomplete/' + stock_name
    // );
    return of({
      count: 123,
      result: [
        {
          description: 'LANDA APP LLC',
          displaySymbol: 'LNDOS',
          symbol: 'LNDOS',
          type: 'Common Stock',
        },
      ],
      data: 123,
    });
  }
}
