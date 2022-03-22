import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';

@Component({
  selector: 'app-transaction-notice',
  templateUrl: './transaction-notice.component.html',
  styleUrls: ['./transaction-notice.component.css'],
})
export class TransactionNoticeComponent implements OnInit {
  @Input() buy_notice: boolean = false;
  @Input() sell_notice: boolean = false;
  @Input() ticker: string = '';
  @Output() buy_cancel: EventEmitter<null> = new EventEmitter();
  @Output() sell_cancel: EventEmitter<null> = new EventEmitter();

  constructor() {}

  ngOnInit(): void {}

  close_buy() {
    this.buy_cancel.emit();
  }

  close_sell() {
    this.sell_cancel.emit();
  }
}
