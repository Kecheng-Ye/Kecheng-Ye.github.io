// module
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule, Routes } from '@angular/router';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatFormField, MatFormFieldModule } from '@angular/material/form-field';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { HighchartsChartModule } from 'highcharts-angular';

// component
import { AppComponent } from './app.component';
import { HeaderComponent } from './components/header/header.component';
import { WatchlistComponent } from './components/watchlist/watchlist.component';
import { PortfolioComponent } from './components/portfolio/portfolio.component';
import { FooterComponent } from './components/footer/footer.component';
import { ButtonComponent } from './components/button/button.component';
import { NaviButtonComponent } from './components/navi-button/navi-button.component';
import { SearchComponent } from './components/search/search.component';
import { NaviSearchButtonComponent } from './components/navi-search-button/navi-search-button.component';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';
import { SearchBarComponent } from './components/search-bar/search-bar.component';
import { StockInfoComponent } from './components/stock-info/stock-info.component';
import { MatInputModule } from '@angular/material/input';
import { StockMainInfoComponent } from './components/stock-main-info/stock-main-info.component';
import { StockSubInfoComponent } from './components/stock-sub-info/stock-sub-info.component';
import { StockMainInfoNameComponent } from './components/stock-main-info-name/stock-main-info-name.component';
import { StockMainInfoPriceComponent } from './components/stock-main-info-price/stock-main-info-price.component';
import { FontAwesomeModule } from '@fortawesome/angular-fontawesome';
import { StockSubInfoSummaryComponent } from './components/stock-sub-info-summary/stock-sub-info-summary.component';
import { StockSubInfoNewsComponent } from './components/stock-sub-info-news/stock-sub-info-news.component';
import { StockSubInfoChartsComponent } from './components/stock-sub-info-charts/stock-sub-info-charts.component';
import { StockSubInfoInsightsComponent } from './components/stock-sub-info-insights/stock-sub-info-insights.component';
import { StockSubInfoSummaryPriceComponent } from './components/stock-sub-info-summary-price/stock-sub-info-summary-price.component';
import { LoadingCircleComponent } from './components/loading-circle/loading-circle.component';
import { StockSubInfoSummaryAboutComponent } from './components/stock-sub-info-summary-about/stock-sub-info-summary-about.component';
import { StockSubInfoSummaryChartComponent } from './components/stock-sub-info-summary-chart/stock-sub-info-summary-chart.component';
import { ChartModule } from 'angular-highcharts';
import { StockSubInfoNewsCardComponent } from './components/stock-sub-info-news-card/stock-sub-info-news-card.component';
import { NewsModalComponent } from './components/news-modal/news-modal.component';
import { StockSubInfoInsightsSocialSintimentsComponent } from './components/stock-sub-info-insights-social-sintiments/stock-sub-info-insights-social-sintiments.component';
import { StockSubInfoInsightsRecommendsComponent } from './components/stock-sub-info-insights-recommends/stock-sub-info-insights-recommends.component';
import { StockSubInfoInsightsEarningComponent } from './components/stock-sub-info-insights-earning/stock-sub-info-insights-earning.component';

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
    HeaderComponent,
    WatchlistComponent,
    PortfolioComponent,
    FooterComponent,
    ButtonComponent,
    NaviButtonComponent,
    SearchComponent,
    NaviSearchButtonComponent,
    SearchBarComponent,
    StockInfoComponent,
    StockMainInfoComponent,
    StockSubInfoComponent,
    StockMainInfoNameComponent,
    StockMainInfoPriceComponent,
    StockSubInfoSummaryComponent,
    StockSubInfoNewsComponent,
    StockSubInfoChartsComponent,
    StockSubInfoInsightsComponent,
    StockSubInfoSummaryPriceComponent,
    LoadingCircleComponent,
    StockSubInfoSummaryAboutComponent,
    StockSubInfoSummaryChartComponent,
    StockSubInfoNewsCardComponent,
    NewsModalComponent,
    StockSubInfoInsightsSocialSintimentsComponent,
    StockSubInfoInsightsRecommendsComponent,
    StockSubInfoInsightsEarningComponent,
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
    RouterModule.forRoot(appRoutes, { enableTracing: false }),
    NgbModule,
    FormsModule,
    BrowserAnimationsModule,
    MatAutocompleteModule,
    MatFormFieldModule,
    MatInputModule,
    ReactiveFormsModule,
    FontAwesomeModule,
    ChartModule,
    HighchartsChartModule,
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
