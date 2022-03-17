import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { NgbPaginationConfig } from '@ng-bootstrap/ng-bootstrap';

enum tab {
  summary = 1,
  news = 2,
  charts = 3,
  insights = 4,
}

@Component({
  selector: 'app-stock-sub-info',
  templateUrl: './stock-sub-info.component.html',
  styleUrls: ['./stock-sub-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockSubInfoComponent implements OnInit {
  active: tab = tab.insights;
  tab = tab;

  constructor(config: NgbPaginationConfig) {

  }

  ngOnInit(): void {}

  onClick(section: tab) {
    this.active = section;
  }
}
