import { Component, OnInit, Input, Output, EventEmitter} from '@angular/core';
import { SearchUpdateService } from 'src/app/services/search-update.service';

@Component({
  selector: 'app-navi-button',
  templateUrl: './navi-button.component.html',
  styleUrls: ['./navi-button.component.css']
})
export class NaviButtonComponent implements OnInit {
  @Input() text:string = "";
  @Input() route_link:string = "";
  @Input() is_active: boolean = false;
  @Output() change_routes = new EventEmitter();
  
  constructor() { 

  }

  ngOnInit(): void {
  }

  onClick() {
    this.change_routes.emit();
  }
}
