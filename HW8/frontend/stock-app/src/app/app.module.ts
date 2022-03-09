// module
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule, Routes } from '@angular/router';

// component
import { AppComponent } from './app.component';
import { StockSummaryComponent } from './components/stock-summary/stock-summary.component';
import { HeaderComponent } from './components/header/header.component';
import { WatchlistComponent } from './components/watchlist/watchlist.component';
import { PortfolioComponent } from './components/portfolio/portfolio.component';
import { SearchHomeComponent } from './components/search-home/search-home.component';
import { FooterComponent } from './components/footer/footer.component';
import { ButtonComponent } from './components/button/button.component';
import { NaviButtonComponent } from './components/navi-button/navi-button.component';
import { SearchComponent } from './components/search/search.component';
import { SearchStockComponent } from './components/search-stock/search-stock.component';
import { NaviSearchButtonComponent } from './components/navi-search-button/navi-search-button.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

const appRoutes: Routes = [
  { path: 'search/:ticker', component: SearchComponent },
  { path: 'watchlist', component: WatchlistComponent },
  { path: 'portfolio', component: PortfolioComponent },
  { path: '', redirectTo: 'search/home', pathMatch: 'full' },
  { path: 'search', redirectTo: 'search/home', pathMatch: 'full' },
];

@NgModule({
  declarations: [
    AppComponent,
    StockSummaryComponent,
    HeaderComponent,
    WatchlistComponent,
    PortfolioComponent,
    FooterComponent,
    ButtonComponent,
    NaviButtonComponent,
    SearchComponent,
    SearchHomeComponent,
    SearchStockComponent,
    NaviSearchButtonComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    RouterModule.forRoot(appRoutes, { enableTracing: false }),
    NgbModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
