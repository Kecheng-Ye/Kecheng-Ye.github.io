import { Component, OnInit, Input } from '@angular/core';
import * as Highcharts from 'highcharts/highstock';
import { Options } from 'highcharts/highstock';
import { Recommend_Info } from '../../data_interface/stock_sub_info';

@Component({
  selector: 'app-stock-sub-info-insights-recommends',
  templateUrl: './stock-sub-info-insights-recommends.component.html',
  styleUrls: ['./stock-sub-info-insights-recommends.component.css'],
})
export class StockSubInfoInsightsRecommendsComponent implements OnInit {
  @Input() data: Recommend_Info[] = [];
  categories: string[] = [];
  strong_buy: number[] = [];
  buy: number[] = [];
  hold: number[] = [];
  sell: number[] = [];
  strong_sell: number[] = [];
  Highcharts: typeof Highcharts = Highcharts;

  chartOptions: Options = {
    chart: {
      type: 'column',
      marginBottom: 90,
    },
    title: {
      text: 'Recommendation Trends',
    },
    yAxis: {
      min: 0,
      title: {
        text: '#Analysis',
        align: 'high',
      },
      stackLabels: {
        enabled: true,
        style: {
          fontWeight: 'bold',
          color: 'gray',
        },
      },
    },
    legend: {
      align: 'center',
      verticalAlign: 'bottom',
      x: 0,
      y: 0,
      itemDistance: 7,
    },
    tooltip: {
      headerFormat: '<b>{point.x}</b><br/>',
      pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}',
    },
    plotOptions: {
      column: {
        stacking: 'normal',
        dataLabels: {
          enabled: true,
        },
      },
    },
    colors: ['#176f37', '#1cb954', '#b88b1d', '#f45b5a', '#813131'],
  };

  constructor() {}

  separate_data() {
    const n = this.data.length;

    for (let i = 0; i < n; i++) {
      const one_rec = this.data[i];
      this.categories.push(one_rec.period);
      this.strong_buy.push(one_rec.strongBuy);
      this.buy.push(one_rec.buy);
      this.hold.push(one_rec.hold);
      this.sell.push(one_rec.sell);
      this.strong_sell.push(one_rec.strongSell);
    }
  }

  ngOnInit(): void {
    this.separate_data();

    this.chartOptions.series = [
      {
        name: 'Strong buy',
        // @ts-ignore
        data: this.strong_buy,
      },
      {
        name: 'Buy',
        // @ts-ignore
        data: this.buy,
      },
      {
        name: 'Hold',
        // @ts-ignore
        data: this.hold,
      },
      {
        name: 'Sell',
        // @ts-ignore
        data: this.sell,
      },
      {
        name: 'Strong Sell',
        // @ts-ignore
        data: this.strong_sell,
      },
    ];

    this.chartOptions.xAxis = {
      categories: this.categories,
    };
  }
}
