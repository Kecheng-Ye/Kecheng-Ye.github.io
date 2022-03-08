import { Component, OnInit } from '@angular/core';
import { StockQueryServiceService } from '../../services/stock-query-service.service';

@Component({
  selector: 'app-stock-summary',
  templateUrl: './stock-summary.component.html',
  styleUrls: ['./stock-summary.component.css'],
})
export class StockSummaryComponent implements OnInit {
  summary: Object = {};

  constructor(private stock_query_service: StockQueryServiceService) {
    stock_query_service.getBrief('TSLA').subscribe((result) => {
      this.summary = result;
    });
  }

  ngOnInit(): void {}
}
