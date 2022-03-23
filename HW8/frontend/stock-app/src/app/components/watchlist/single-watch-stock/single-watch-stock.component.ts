import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { single_watch_info } from '../../../data_interface/watchlist';
import { faCaretDown, faCaretUp } from '@fortawesome/free-solid-svg-icons';
import { round } from '../../../util';
import { Router } from "@angular/router";
import { SearchUpdateService } from "../../../services/search-update.service";

@Component({
  selector: 'app-single-watch-stock',
  templateUrl: './single-watch-stock.component.html',
  styleUrls: ['./single-watch-stock.component.css'],
})
export class SingleWatchStockComponent implements OnInit {
  @Input()
  get data() {
    return this._data;
  }
  set data(new_data: single_watch_info) {
    this._data = {
      ...new_data,
      c: round(new_data.c, 2),
      d: round(new_data.d, 2),
      dp: round(new_data.dp, 2),
    };
  }
  private _data: single_watch_info = {} as single_watch_info;

  @Output() delete_event: EventEmitter<number> = new EventEmitter<number>();
  faCaretDown = faCaretDown;
  faCaretUp = faCaretUp;

  constructor(private router: Router, private ticker_query: SearchUpdateService) {}

  ngOnInit(): void {}

  on_delete() {
    this.delete_event.emit(this.data.index);
  }

  on_route() {
    this.router.navigateByUrl('/search/' + this.data.ticker).then(r => this.ticker_query.fresh_header());
  }
}
