import { Component, OnInit, Output, EventEmitter } from '@angular/core';
import { Subscription } from 'rxjs';
import { SearchUpdateService } from 'src/app/services/search-update.service';
import { NaviButtonComponent } from '../navi-button/navi-button.component';
SearchUpdateService;

@Component({
  selector: 'app-navi-search-button',
  templateUrl: '../navi-button/navi-button.component.html',
  styleUrls: [
    './navi-search-button.component.css',
    '../navi-button/navi-button.component.css',
  ],
})
export class NaviSearchButtonComponent
  extends NaviButtonComponent
  implements OnInit
{
  is_home_page: boolean = false;
  is_home_subscrib: Subscription = new Subscription();
  ticker: any;
  ticker_subscrib: Subscription = new Subscription();
  @Output() should_active:EventEmitter<boolean> = new EventEmitter();

  constructor(private search_update: SearchUpdateService) {
    super();
    this.is_home_subscrib = this.search_update
      .get_search_state()
      .subscribe((home_page_state) => {
        this.is_home_page = home_page_state;
      });

    this.ticker_subscrib = this.search_update
      .fetch_prev_ticker()
      .subscribe((prev_ticker) => {
        this.ticker = prev_ticker;
        this.route_link =
          'search/' + (this.ticker == '' ? 'home' : this.ticker);
      });
  }

  override onClick(): void {
    this.should_active.emit(!this.is_home_page);
  }
}
