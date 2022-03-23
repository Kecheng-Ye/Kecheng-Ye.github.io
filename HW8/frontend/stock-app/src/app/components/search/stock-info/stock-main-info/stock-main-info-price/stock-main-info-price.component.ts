import { Component, Input, OnInit } from '@angular/core';
import { stock_price } from '../../../../../data_interface/stock_main_info';
import * as moment from 'moment';
import { round } from '../../../../../util';
import { faCaretDown, faCaretUp } from '@fortawesome/free-solid-svg-icons';
import { StockQueryService } from "../../../../../services/stock-query.service";

@Component({
  selector: 'app-stock-main-info-price',
  templateUrl: './stock-main-info-price.component.html',
  styleUrls: ['./stock-main-info-price.component.css'],
})
export class StockMainInfoPriceComponent implements OnInit {
  @Input()
  get price(): any {
    return this._price;
  }

  set price(new_price: stock_price) {
    this._price = {
      c: round(new_price.c, 2),
      d: round(new_price.d, 2),
      dp: round(new_price.dp, 2),
      up: new_price.d > 0,
      down: new_price.d < 0,
      cur_time: moment().format('YYYY-MM-DD HH:mm:ss'),
    };

    this._price.color = this._price.up
      ? 'green'
      : this._price.down
      ? 'red'
      : 'black';

    this.stock_query.update_color(this._price.color);
  }
  private _price: any = {};
  round = round;
  faCaretUp = faCaretUp;
  faCaretDown = faCaretDown;

  constructor(private stock_query: StockQueryService) {}

  ngOnInit(): void {}
}
