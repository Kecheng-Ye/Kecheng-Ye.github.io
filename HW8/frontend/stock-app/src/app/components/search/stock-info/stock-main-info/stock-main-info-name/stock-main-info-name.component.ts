import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { stock_name_block } from '../../../../../data_interface/stock_main_info';

@Component({
  selector: 'app-stock-main-info-name',
  templateUrl: './stock-main-info-name.component.html',
  styleUrls: ['./stock-main-info-name.component.css'],
})
export class StockMainInfoNameComponent implements OnInit {
  @Input() stock_name: stock_name_block = {} as stock_name_block;
  @Output() watch_list_click = new EventEmitter<boolean>();
  @Output() buy_click = new EventEmitter<boolean>();
  @Output() sell_click = new EventEmitter<boolean>();

  constructor() {}

  ngOnInit(): void {}

  watch_list_onClick() {
    this.watch_list_click.emit(!this.stock_name.is_in_watch_list);
  }

  buy_onClick() {
    this.buy_click.emit();
  }

  sell_onClick() {
    this.sell_click.emit();
  }
}
