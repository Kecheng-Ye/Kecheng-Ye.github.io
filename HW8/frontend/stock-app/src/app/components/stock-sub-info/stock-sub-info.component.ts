import {Component, Input, OnInit, ViewEncapsulation} from '@angular/core';

@Component({
  selector: 'app-stock-sub-info',
  templateUrl: './stock-sub-info.component.html',
  styleUrls: ['./stock-sub-info.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class StockSubInfoComponent implements OnInit {
  @Input() ticker: string = "";

  constructor() { }

  ngOnInit(): void {
  }

}
