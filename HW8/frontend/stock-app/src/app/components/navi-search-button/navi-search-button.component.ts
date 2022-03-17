import {Component, OnInit, Output, EventEmitter, ViewEncapsulation} from '@angular/core';
import { Subscription } from 'rxjs';
import { SearchUpdateService } from 'src/app/services/search-update.service';
import { NaviButtonComponent } from '../navi-button/navi-button.component';

@Component({
  selector: 'app-navi-search-button',
  templateUrl: '../navi-button/navi-button.component.html',
  styleUrls: [
    './navi-search-button.component.css',
    '../navi-button/navi-button.component.css',
  ],
  encapsulation: ViewEncapsulation.Emulated,
})
export class NaviSearchButtonComponent
  extends NaviButtonComponent
  implements OnInit
{
  is_home_page: boolean = false;
  ticker: any;
  @Output() should_active:EventEmitter<boolean> = new EventEmitter();

  constructor(private search_update: SearchUpdateService) {
    super();
    this.search_update
      .get_search_state()
      .subscribe((home_page_state) => {
        this.is_home_page = home_page_state;
      });

    this.search_update
      .fetch_ticker()
      .subscribe(([prev_ticker, _]) => {
        this.ticker = prev_ticker;
        this.route_link =
          'search/' + (this.ticker == '' ? 'home' : this.ticker);
      });
  }

  override onClick(): void {
    this.should_active.emit(!this.is_home_page);
  }
}
