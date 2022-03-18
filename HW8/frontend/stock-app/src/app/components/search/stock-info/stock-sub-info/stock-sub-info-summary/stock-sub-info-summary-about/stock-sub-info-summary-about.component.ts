import {Component, Input, OnInit} from '@angular/core';
import { About_Info } from '../../../../../../data_interface/stock_sub_info';

@Component({
  selector: 'app-stock-sub-info-summary-about',
  templateUrl: './stock-sub-info-summary-about.component.html',
  styleUrls: ['./stock-sub-info-summary-about.component.css'],
})
export class StockSubInfoSummaryAboutComponent implements OnInit {
  @Input() about: About_Info = {
    ipo: '1980-12-12',
    finnhubIndustry: 'Technology',
    weburl: 'https://www.apple.com/',
    peers: [
      'AAPL',
      'DELL',
      'HPQ',
      'HPE',
      '1337.HK',
      'NTAP',
      'WDC',
      'PSTG',
      'XRX',
      'IONQ',
    ],
  };
  constructor() {}

  ngOnInit(): void {}
}
