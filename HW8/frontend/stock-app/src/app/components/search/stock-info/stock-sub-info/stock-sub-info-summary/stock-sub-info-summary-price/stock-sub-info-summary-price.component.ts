import { Component, Input, OnInit } from '@angular/core';
import { Price_Summary } from '../../../../../../data_interface/stock_sub_info';
import { round, UNDEFINED_NUM } from '../../../../../../util';

@Component({
  selector: 'app-stock-sub-info-summary-price',
  templateUrl: './stock-sub-info-summary-price.component.html',
  styleUrls: ['./stock-sub-info-summary-price.component.css'],
})
export class StockSubInfoSummaryPriceComponent implements OnInit {
  @Input()
  get summary() {
    return this._summary;
  }
  set summary(new_syummary) {
    this._summary = {
      h: round(new_syummary.h,2),
      l: round(new_syummary.l,2),
      o: round(new_syummary.o,2),
      pc: round(new_syummary.pc,2),
      d: round(new_syummary.d,2),
    }
  }

  private _summary: Price_Summary = {
    h: UNDEFINED_NUM,
    l: UNDEFINED_NUM,
    o: UNDEFINED_NUM,
    pc: UNDEFINED_NUM,
    d: UNDEFINED_NUM,
  };

  round = round;

  constructor() {}

  ngOnInit(): void {}
}
