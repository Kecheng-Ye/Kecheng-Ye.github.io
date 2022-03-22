import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { buying_info, transaction } from '../../../data_interface/portfolio';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';
import { FormControl } from '@angular/forms';
import { round } from '../../../util';

@Component({
  selector: 'app-buying-modal',
  templateUrl: './buying-modal.component.html',
  styleUrls: ['./buying-modal.component.css'],
})
export class BuyingModalComponent implements OnInit {
  @Input() data: buying_info = {} as buying_info;
  @Input() balance: number = 0;
  @Output() buy_event: EventEmitter<transaction> =
    new EventEmitter<transaction>();
  limit: number = -1;
  round = round;
  public myControl = new FormControl();

  constructor(public activeModal: NgbActiveModal) {}

  ngOnInit(): void {
    this.myControl.setValue(0);
    this.limit = this.balance / this.data.price;
  }

  on_click_buy() {
    this.activeModal.close();
    this.buy_event.emit({
      price: this.data.price,
      shares: this.myControl.value,
    });
  }
}
