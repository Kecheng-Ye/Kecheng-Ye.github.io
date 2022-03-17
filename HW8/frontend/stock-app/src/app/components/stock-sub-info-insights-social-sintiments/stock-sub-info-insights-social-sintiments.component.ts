import { Component, Input, OnInit } from '@angular/core';
import { Sentiments_For_Plot } from '../../data_interface/stock_sub_info';

@Component({
  selector: 'app-stock-sub-info-insights-social-sintiments',
  templateUrl: './stock-sub-info-insights-social-sintiments.component.html',
  styleUrls: ['./stock-sub-info-insights-social-sintiments.component.css'],
})
export class StockSubInfoInsightsSocialSintimentsComponent implements OnInit {
  @Input() data: { reddit: Sentiments_For_Plot; twitter: Sentiments_For_Plot, name: string;} =
    { reddit: {} as Sentiments_For_Plot, twitter: {} as Sentiments_For_Plot, name: ""};

  constructor() {}

  ngOnInit(): void {}
}
