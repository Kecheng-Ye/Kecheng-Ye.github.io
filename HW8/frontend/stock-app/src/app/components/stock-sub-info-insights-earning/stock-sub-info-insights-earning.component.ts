import { Component, Input, OnInit } from "@angular/core";
import { Earning_Info } from "../../data_interface/stock_sub_info";
import * as Highcharts from 'highcharts/highstock';
import { Options } from 'highcharts/highstock';
import { round } from "../../util";

@Component({
  selector: 'app-stock-sub-info-insights-earning',
  templateUrl: './stock-sub-info-insights-earning.component.html',
  styleUrls: ['./stock-sub-info-insights-earning.component.css']
})
export class StockSubInfoInsightsEarningComponent implements OnInit {
  @Input() data: Earning_Info[] = [];
  Highcharts: typeof Highcharts = Highcharts;
  categories: string[] = [];
  actual: number[] = [];
  estimate: number[] = [];
  round = round;
  chartOptions: Options = {};

  constructor() { }

  ngOnInit(): void {
    this.separate_date();
    this.construct_plot();
  }

  separate_date() {
    const n = this.data.length;

    for(let i = 0; i < n; i++) {
      const one_rec = this.data[i];
      this.categories.push(`<small>${one_rec.period}</small><br>Surprise: ${round(one_rec.surprise, 2)}`)
      this.estimate.push(round(one_rec.estimate, 2));
      this.actual.push(round(one_rec.actual, 2));
    }
  }

  construct_plot() {
    this.chartOptions = {
      chart: {
        type: 'spline',
      },

      title: {
        text: 'Historical EPS Surprise'
      },

      yAxis: {
        title: {
          text: 'Quaterly EPS'
        }
      },

      xAxis: {
        categories: this.categories,
        // @ts-ignore
        useHTML: true,
      },

      legend: {
        align: 'center',
        verticalAlign: 'bottom',
        x: 0,
        y: 0,
      },

      tooltip: {
        headerFormat: '{point.x}<br>',
        shared: true,
        useHTML: true,
      },

      label: {
        enabled: false
      },

      series: [{
        name: 'estimate',
        // @ts-ignore
        data: this.estimate,
        // @ts-ignore
        label: false,
      }, {
        name: 'actual',
        // @ts-ignore
        data: this.actual,
        // @ts-ignore
        label: false,
      }],

      responsive: {
        rules: [{
          condition: {
            maxWidth: 500
          },
          chartOptions: {
            legend: {
              layout: 'horizontal',
              align: 'center',
              verticalAlign: 'bottom'
            }
          }
        }]
      }
    }
  }

}
