import { Component, Input, OnInit } from '@angular/core';
import { Price_Summary } from '../../data_interface/stock_sub_info';
import { UNDEFINED_NUM } from '../../util';

@Component({
  selector: 'app-stock-sub-info-summary-price',
  templateUrl: './stock-sub-info-summary-price.component.html',
  styleUrls: ['./stock-sub-info-summary-price.component.css'],
})
export class StockSubInfoSummaryPriceComponent implements OnInit {
  @Input() summary: Price_Summary = {
    h: UNDEFINED_NUM,
    l: UNDEFINED_NUM,
    o: UNDEFINED_NUM,
    pc: UNDEFINED_NUM,
  };

  constructor() {}

  ngOnInit(): void {}
}
