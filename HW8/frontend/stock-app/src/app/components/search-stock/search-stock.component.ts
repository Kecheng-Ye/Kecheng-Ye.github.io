import { Component, OnInit, Input } from '@angular/core';

@Component({
  selector: 'app-search-stock',
  templateUrl: './search-stock.component.html',
  styleUrls: ['./search-stock.component.css']
})
export class SearchStockComponent implements OnInit {
  @Input() ticker: string = "";

  constructor() { }

  ngOnInit(): void {
  }

}
