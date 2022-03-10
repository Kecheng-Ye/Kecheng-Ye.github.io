// module
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { RouterModule, Routes } from '@angular/router';
import {FormsModule, ReactiveFormsModule} from '@angular/forms';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import {MatFormField, MatFormFieldModule} from "@angular/material/form-field";
import { MatAutocompleteModule } from '@angular/material/autocomplete';

// component
import { AppComponent } from './app.component';
import { StockSummaryComponent } from './components/stock-summary/stock-summary.component';
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
import {MatInputModule} from "@angular/material/input";

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
    NaviSearchButtonComponent,
    SearchBarComponent,
    StockInfoComponent,
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
  ],
  providers: [],
  bootstrap: [AppComponent],
})
export class AppModule {}
