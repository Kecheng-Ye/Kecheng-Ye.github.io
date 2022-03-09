import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { SearchUpdateService } from "../../services/search-update.service";
import { Subscription } from 'rxjs';

const HOME_PAGE: string = "home";

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {
  ticker: any;
  ticker_subscrib: Subscription = new Subscription();
  is_home_page: boolean = false;
  is_home_subscrib: Subscription = new Subscription();

  constructor(private activatedRoute : ActivatedRoute, private search_update: SearchUpdateService) {
    this.is_home_subscrib = this.search_update.get_search_state().subscribe((home_page_state) => {
      this.is_home_page = home_page_state;
    });

    this.ticker_subscrib = this.search_update.fetch_prev_ticker().subscribe((prev_ticker) => {
      this.ticker = prev_ticker;
    });
  }

  ngOnInit(): void {
    this.activatedRoute.paramMap.subscribe(params => {
      const new_ticker = params.get('ticker');
      if(new_ticker != null) {
        this.ticker = new_ticker
        this.is_home_page = (this.ticker === HOME_PAGE);
        this.search_update.update_search(this.is_home_page, this.ticker);
      }
    });
  }

}
