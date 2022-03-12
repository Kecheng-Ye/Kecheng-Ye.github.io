import {Component, Input, OnInit} from '@angular/core';
import {stock_name_block} from "../../data_interface/stock_main_info";
import {trim_undefined} from "../../util";

@Component({
  selector: 'app-stock-main-info-name',
  templateUrl: './stock-main-info-name.component.html',
  styleUrls: ['./stock-main-info-name.component.css'],
})
export class StockMainInfoNameComponent implements OnInit {
  @Input() stock_name: stock_name_block = {} as stock_name_block;
  trim_undefined = trim_undefined;

  constructor() {}

  ngOnInit(): void {}
}
