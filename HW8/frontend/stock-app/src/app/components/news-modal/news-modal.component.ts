import { Component, OnInit, Input } from '@angular/core';
import {NgbActiveModal} from '@ng-bootstrap/ng-bootstrap';
import { News } from "../../data_interface/stock_sub_info";
import * as moment from "moment";

@Component({
  selector: 'app-news-modal',
  templateUrl: './news-modal.component.html',
  styleUrls: ['./news-modal.component.css']
})
export class NewsModalComponent implements OnInit {
  @Input()
  get news() {
    return this._news;
  }
  set news(new_news) {
    this._news = {}
    this._news = {...new_news, time: moment.unix(new_news.datetime).format('MMMM DD,YYYY')}
  }
  private _news: any;

  constructor(public activeModal: NgbActiveModal) { }

  ngOnInit(): void {
  }

}
