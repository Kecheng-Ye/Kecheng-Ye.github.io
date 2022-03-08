// module
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';

// component
import { AppComponent } from './app.component';
import { StockSummaryComponent } from './components/stock-summary/stock-summary.component';

@NgModule({
  declarations: [
    AppComponent,
    StockSummaryComponent
  ],
  imports: [
    BrowserModule,
    HttpClientModule,
  ],
  providers: [],
  bootstrap: [AppComponent]
})
export class AppModule { }
