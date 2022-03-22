import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { round } from 'src/app/util';
import { one_portfolio_entry } from '../../../data_interface/portfolio';
import { faCaretDown, faCaretUp } from '@fortawesome/free-solid-svg-icons';

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

  constructor() {}

  ngOnInit(): void {}

  buy_on_click() {
    this.buy_event.emit(this.data.index);
  }

  sell_on_click() {
    this.sell_event.emit(this.data.index);
  }
}
