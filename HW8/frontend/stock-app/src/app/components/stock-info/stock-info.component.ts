import { Component, OnInit, Input} from '@angular/core';

@Component({
  selector: 'app-stock-info',
  templateUrl: './stock-info.component.html',
  styleUrls: ['./stock-info.component.css']
})
export class StockInfoComponent implements OnInit {

  @Input() ticker: string = "";

  constructor() { }

  ngOnInit(): void {
  }

}
