import { Component, OnInit } from '@angular/core';
import * as Highcharts from 'highcharts/highstock';
import IndicatorsCore from 'highcharts/indicators/indicators';
import VBP from 'highcharts/indicators/volume-by-price';
import { Historical_Record } from '../../../../../data_interface/stock_sub_info';
import { StockQueryService } from '../../../../../services/stock-query.service';
import { SearchUpdateService } from '../../../../../services/search-update.service';
import * as moment from 'moment';
import { Options } from 'highcharts/highstock';
import { of, switchMap } from "rxjs";
import { PreviousStateService } from "../../../../../services/previous-state.service";

IndicatorsCore(Highcharts);
VBP(Highcharts);

@Component({
  selector: 'app-stock-sub-info-charts',
  templateUrl: './stock-sub-info-charts.component.html',
  styleUrls: ['./stock-sub-info-charts.component.css'],
})
export class StockSubInfoChartsComponent implements OnInit {
  ticker: string = '';
  ohlc: number[][] = [];
  volume: number[][] = [];
  Highcharts: typeof Highcharts = Highcharts;
  is_loading = true;
  groupingUnits = [
    [
      'day', // unit name
      [1], // allowed multiples
    ],
  ];
  chartOptions: Options = {
    rangeSelector: {
      selected: 2,
    },

    subtitle: {
      text: 'With SMA and Volume by Price technical indicators',
    },

    yAxis: [
      {
        startOnTick: false,
        endOnTick: false,
        labels: {
          align: 'right',
          x: -3,
        },
        title: {
          text: 'OHLC',
        },
        height: '60%',
        lineWidth: 2,
        resize: {
          enabled: true,
        },
      },
      {
        labels: {
          align: 'right',
          x: -3,
        },
        title: {
          text: 'Volume',
        },
        top: '65%',
        height: '35%',
        offset: 0,
        lineWidth: 2,
      },
    ],

    tooltip: {
      split: true,
    },

    plotOptions: {
      series: {
        dataGrouping: {
          // @ts-ignore
          units: this.groupingUnits
        }
      },
    },

    series: [],
  };

  constructor(
    private stock_query: StockQueryService,
    private ticker_query: SearchUpdateService,
    private prev_info_query: PreviousStateService
  ) {}

  joined_query_list = () => {
    this.is_loading = true;
    this.ohlc = [];
    this.volume = [];
    return this.stock_query.get_historical_record(this.ticker, moment());
  };

  retrieve_data = (data: Historical_Record | [number[][], number[][]]) => {
    if(Array.isArray(data)) {
      const [prev_olhc, prev_volume] = data;
      this.ohlc = prev_olhc;
      this.volume = prev_volume;
    }else{
      this.retrieve_query(data);
    }

    this.chartOptions.title = {
      text: `${this.ticker} Historical`,
    };
    this.chartOptions.series = [
      {
        type: 'candlestick',
        name: 'AAPL',
        id: 'aapl',
        zIndex: 2,
        data: this.ohlc,
      },
      {
        type: 'column',
        name: 'Volume',
        id: 'volume',
        data: this.volume,
        yAxis: 1,
      },
      {
        type: 'vbp',
        linkedTo: 'aapl',
        params: {
          volumeSeriesID: 'volume',
        },
        dataLabels: {
          enabled: false,
        },
        zoneLines: {
          enabled: false,
        },
      },
      {
        type: 'sma',
        linkedTo: 'aapl',
        zIndex: 1,
        marker: {
          enabled: false,
        },
      },
    ];
    this.is_loading = false;
  }

  retrieve_query = (data: Historical_Record) => {
    let n = data.t.length;
    for (let i = 0; i < n; i++) {
      this.ohlc.push([
        data.t[i] * 1000, // the date
        data.o[i], // open
        data.h[i], // high
        data.l[i], // low
        data.c[i], // close
      ]);

      this.volume.push([
        data.t[i] * 1000, // the date
        data.v[i], // the volume
      ]);
    }

    this.prev_info_query.update_historical_record([this.ohlc, this.volume]);
  };

  ngOnInit(): void {
    this.ticker_query.fetch_ticker()
      .pipe(
        switchMap(([ticker, ticker_change]) => {
          this.ticker = ticker;
          if (ticker_change) {
            return this.joined_query_list();
          } else {
            return this.prev_info_query.get_prev_historical_record();
          }
        })
      )
      .subscribe(this.retrieve_data);

  }
}
