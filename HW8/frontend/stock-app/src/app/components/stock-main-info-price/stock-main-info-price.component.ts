import { Component, Input, OnInit } from '@angular/core';
import { stock_price } from '../../data_interface/stock_main_info';
import * as moment from 'moment';
import { round} from "../../util";

@Component({
  selector: 'app-stock-main-info-price',
  templateUrl: './stock-main-info-price.component.html',
  styleUrls: ['./stock-main-info-price.component.css'],
})
export class StockMainInfoPriceComponent implements OnInit {
  @Input() price: stock_price = {} as stock_price;
  round = round;
  constructor() {}

  ngOnInit(): void {}

  transfer_time() {
    return moment().format('YYYY-MM-DD HH:mm:ss');
  }
}
