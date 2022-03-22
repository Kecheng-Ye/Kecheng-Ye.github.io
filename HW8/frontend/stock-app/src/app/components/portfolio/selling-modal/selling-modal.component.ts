import { Component, EventEmitter, Input, OnInit, Output } from '@angular/core';
import { selling_info, transaction } from '../../../data_interface/portfolio';
import { FormControl } from '@angular/forms';
import { NgbActiveModal } from '@ng-bootstrap/ng-bootstrap';
import { round } from 'src/app/util';

@Component({
  selector: 'app-selling-modal',
  templateUrl: './selling-modal.component.html',
  styleUrls: ['./selling-modal.component.css'],
})
export class SellingModalComponent implements OnInit {
  @Input() data: selling_info = {} as selling_info;
  @Input() balance: number = 0;
  @Output() sell_event: EventEmitter<transaction> =
    new EventEmitter<transaction>();
  limit: number = -1;
  round = round;
  public myControl = new FormControl();

  constructor(public activeModal: NgbActiveModal) {}

  ngOnInit(): void {
    this.myControl.setValue(0);
    this.limit = this.data.shares_remain;
  }

  on_click_sell() {
    this.activeModal.close();
    this.sell_event.emit({
      price: this.data.price,
      shares: this.myControl.value,
    });
  }
}
