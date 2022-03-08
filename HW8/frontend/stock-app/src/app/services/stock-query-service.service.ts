import { Injectable } from '@angular/core';
import { Observable } from "rxjs";
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class StockQueryServiceService {
  api_url: string = "/api";

  constructor(private http: HttpClient) { }

  getBrief(ticker: string): Observable<Object> {
    return this.http.get<Object>(this.api_url + '/brief/' + ticker);
  }
}
