import { Component, Input, OnInit } from '@angular/core';
import { StockChart } from 'angular-highcharts';
import { Hourly_Price_Record } from '../../data_interface/stock_sub_info';
import { StockQueryService } from "../../services/stock-query.service";

@Component({
  selector: 'app-stock-sub-info-summary-chart',
  templateUrl: './stock-sub-info-summary-chart.component.html',
  styleUrls: ['./stock-sub-info-summary-chart.component.css'],
})
export class StockSubInfoSummaryChartComponent implements OnInit {
  @Input()
  get hourly_price(): any {
    return this._hourly_price;
  }
  set hourly_price(new_hourly: Hourly_Price_Record) {
    for (let i = 0; i < new_hourly['t'].length; i++) {
      this._hourly_price.push([new_hourly['t'][i] * 1000, new_hourly['c'][i]]);
    }
  }
  private _hourly_price: any = [];
  @Input() ticker: string = '';
  chart: any = null;
  color: string = 'black';

  constructor(private stock_query: StockQueryService) {}

  ngOnInit(): void {
    this.stock_query.get_color().subscribe((new_color) => {
      this.color = new_color;
      this.chart = new StockChart({
        rangeSelector: {
          enabled: false,
          inputEnabled: false
        },

        title: {
          text: `${this.ticker} Hourly Price Variation`,
        },

        navigator: {
          enabled: false
        },

        series: [
          {
            name: 'Hourly Price',
            data: this.hourly_price,
            type: 'line',
            color: this.color,
            tooltip: {
              valueDecimals: 2,
            },
          },
        ],
      });
    })
  }
}
