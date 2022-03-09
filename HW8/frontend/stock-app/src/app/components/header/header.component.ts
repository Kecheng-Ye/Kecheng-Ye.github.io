import { Component, OnInit } from '@angular/core';
import { Location } from '@angular/common';

@Component({
  selector: 'app-header',
  templateUrl: './header.component.html',
  styleUrls: ['./header.component.css']
})
export class HeaderComponent implements OnInit {
  search_active: boolean = false;
  watchlist_active: boolean = false;
  portfolio_active: boolean = false;

  constructor(private location: Location) {
  }

  ngOnInit(): void {
    const components = this.location.path().split('/');
    this.search_active = components.includes("search") && !components.includes("home");
    this.watchlist_active = components.includes("watchlist");
    this.portfolio_active = components.includes("portfolio");
  }

  refresh_all() {
    this.search_active = false;
    this.watchlist_active = false;
    this.portfolio_active = false;
  }

  click_search(should_active: boolean) {
    this.refresh_all();
    this.search_active = should_active;
  }

  click_watchlist() {
    this.refresh_all();
    this.watchlist_active = true;
  }

  click_portfolio() {
    this.refresh_all();
    this.portfolio_active = true;
  }
}
