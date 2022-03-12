import { Component, Input, OnInit, ViewEncapsulation } from '@angular/core';
import { stock_main_info } from '../../data_interface/stock_main_info';
import * as moment from 'moment';

@Component({
  selector: 'app-stock-main-info',
  templateUrl: './stock-main-info.component.html',
  styleUrls: ['./stock-main-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockMainInfoComponent implements OnInit {
  @Input() ticker: string = '';
  @Input() main_info_data: stock_main_info = {} as stock_main_info;
  moment = moment;

  constructor() {}

  ngOnInit(): void {}

  is_market_open(timestamp: number): boolean {
    const cur = moment();
    const market_time = moment.unix(timestamp).add(5, 'minutes');

    return cur < market_time;
  }


}
