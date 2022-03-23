import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { round } from 'src/app/util';
import { one_portfolio_entry } from '../../../data_interface/portfolio';
import { faCaretDown, faCaretUp } from '@fortawesome/free-solid-svg-icons';
import { Router } from '@angular/router';
import { SearchUpdateService } from '../../../services/search-update.service';

@Component({
  selector: 'app-single-portfolio-record',
  templateUrl: './single-portfolio-record.component.html',
  styleUrls: ['./single-portfolio-record.component.css'],
})
export class SinglePortfolioRecordComponent implements OnInit {
  @Input() data: one_portfolio_entry = {} as one_portfolio_entry;
  round = round;
  @Output() buy_event: EventEmitter<number> = new EventEmitter();
  @Output() sell_event: EventEmitter<number> = new EventEmitter();
  faCaretDown = faCaretDown;
  faCaretUp = faCaretUp;

  constructor(
    private router: Router,
    private ticker_query: SearchUpdateService
  ) {}

  ngOnInit(): void {}

  buy_on_click() {
    this.buy_event.emit(this.data.index);
  }

  sell_on_click() {
    this.sell_event.emit(this.data.index);
  }

  on_route() {
    this.router
      .navigateByUrl('/search/' + this.data.ticker)
      .then((r) => this.ticker_query.fresh_header());
  }
}
