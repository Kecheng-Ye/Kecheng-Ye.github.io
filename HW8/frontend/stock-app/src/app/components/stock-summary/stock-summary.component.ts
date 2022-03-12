import {Component, OnInit, ViewEncapsulation} from '@angular/core';
import { StockQueryService } from '../../services/stock-query.service';

@Component({
  selector: 'app-stock-summary',
  templateUrl: './stock-summary.component.html',
  styleUrls: ['./stock-summary.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockSummaryComponent implements OnInit {
  summary: Object = {};

  constructor(private stock_query_service: StockQueryService) {}

  ngOnInit(): void {}
}
