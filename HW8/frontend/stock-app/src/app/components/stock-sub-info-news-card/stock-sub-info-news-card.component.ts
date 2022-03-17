import { Component, Input, OnInit } from '@angular/core';
import { News } from '../../data_interface/stock_sub_info';
import { NgbModal } from '@ng-bootstrap/ng-bootstrap';
import { NewsModalComponent } from '../news-modal/news-modal.component';

@Component({
  selector: 'app-stock-sub-info-news-card',
  templateUrl: './stock-sub-info-news-card.component.html',
  styleUrls: ['./stock-sub-info-news-card.component.css'],
})
export class StockSubInfoNewsCardComponent implements OnInit {
  @Input() news: News = {
    category: 'company',
    datetime: 1647288360,
    headline: 'Apple Has Bad News for Customers',
    id: 107151038,
    image:
      'https://s.yimg.com/uu/api/res/1.2/Q_0XFsmkn.sruqPeCfI3dA--~B/aD01MTI7dz03Njg7YXBwaWQ9eXRhY2h5b24-/https://media.zenfs.com/en/insidermonkey.com/0ccf9150fdcc64b52bd8670c737e393d',
    related: 'AAPL',
    source: 'Yahoo',
    summary:
      'If you\'re looking forward t the latest suite of Apple  products from its first launch event held online last week, there maybe an unexpected kink that could disrupt your plans to upgrade to the new low-cost iPhone SE or the latest iPad Air 5 or the wildly popular Mac Studio.  The biggest manufacturer of Apple iPhones, Foxconn Technology Group has "suspended" operations in China\'s industrial hub Shenzhen following a spike in Covid-19 cases in the region.  "The operation of Foxconn in Shenzhen China has been suspended from March 14 onwards in compliance with the local government\'s new COVID-19 policy," according to an emailed statement shared widely in media reports. "The date of factory resumption is to be advised by the local government," Foxconn added.',
    url: 'https://finnhub.io/api/news?id=6e9a2b18cca93ea3eac9805c88c4b5baad49c4de50b4994e95cd6c102738a322',
  } as News;
  constructor(private modalService: NgbModal) {}

  ngOnInit(): void {}

  open() {
    const news_modal = this.modalService.open(NewsModalComponent);
    news_modal.componentInstance.news = this.news;
  }
}
