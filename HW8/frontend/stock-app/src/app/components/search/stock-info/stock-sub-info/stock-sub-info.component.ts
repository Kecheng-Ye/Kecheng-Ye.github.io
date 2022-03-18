import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { NgbPaginationConfig } from '@ng-bootstrap/ng-bootstrap';

enum tab {
  Summary = 1,
  News = 2,
  Charts = 3,
  Insights = 4,
}

@Component({
  selector: 'app-stock-sub-info',
  templateUrl: './stock-sub-info.component.html',
  styleUrls: ['./stock-sub-info.component.css'],
  encapsulation: ViewEncapsulation.None,
})
export class StockSubInfoComponent implements OnInit {
  sections: tab[] = [tab.Summary, tab.News, tab.Charts, tab.Insights];
  active: tab = tab.Summary;
  tab = tab;

  constructor(config: NgbPaginationConfig) {

  }

  ngOnInit(): void {}

  onClick(section: tab) {
    this.active = section;
  }
}
