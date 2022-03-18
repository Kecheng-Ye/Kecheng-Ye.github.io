import { Component, Input, OnInit } from '@angular/core';
import * as Highcharts from 'highcharts/highstock';
import { Options } from 'highcharts/highstock';
import { Hourly_Price_Record } from '../../../../../../data_interface/stock_sub_info';
import { StockQueryService } from '../../../../../../services/stock-query.service';

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
  @Input()
  get color() {
    return this._color;
  }
  set color(new_color: string) {
    this._color = new_color;
    this.update_plot();
  }
  private _color: string = "";
  Highcharts: typeof Highcharts = Highcharts;
  chartOptions: Options = {
    rangeSelector: {
      enabled: false,
      inputEnabled: false,
    },

    navigator: {
      enabled: false,
    },
  };
  updateFlag = false;

  constructor(private stock_query: StockQueryService) {}

  ngOnInit(): void {
    this.update_plot();
  }

  update_plot() {
    this.chartOptions.series = [
      {
        name: 'Hourly Price',
        data: this.hourly_price,
        type: 'line',
        color: this.color,
        tooltip: {
          valueDecimals: 2,
        },
      },
    ];

    this.chartOptions.title = {
      text: `${this.ticker} Hourly Price Variation`,
    };

    this.updateFlag = true;
  }
}
