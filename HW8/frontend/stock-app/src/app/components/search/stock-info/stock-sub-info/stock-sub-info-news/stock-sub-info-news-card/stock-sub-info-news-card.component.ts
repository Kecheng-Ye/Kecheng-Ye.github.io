import { Component, Input, OnInit } from '@angular/core';
import { News } from '../../../../../../data_interface/stock_sub_info';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { NewsModalComponent } from './news-modal/news-modal.component';

@Component({
  selector: 'app-stock-sub-info-news-card',
  templateUrl: './stock-sub-info-news-card.component.html',
  styleUrls: ['./stock-sub-info-news-card.component.css'],
})
export class StockSubInfoNewsCardComponent implements OnInit {
  @Input() news: News = {} as News;
  constructor(private modalService: NgbModal) {}

  ngOnInit(): void {}

  open() {
    const news_modal = this.modalService.open(NewsModalComponent);
    news_modal.componentInstance.news = this.news;
  }
}
