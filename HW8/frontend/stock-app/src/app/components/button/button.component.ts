import {Component, OnInit, Input, Output, EventEmitter, ViewEncapsulation} from '@angular/core';

@Component({
  selector: 'app-button',
  templateUrl: './button.component.html',
  styleUrls: ['./button.component.css'],
  encapsulation: ViewEncapsulation.Emulated,
})
export class ButtonComponent implements OnInit {
  @Input() text: string | undefined;
  @Input() bg_color: string | undefined;
  @Input() text_color: string | undefined;
  @Output() btnclick = new EventEmitter();

  constructor() { }

  ngOnInit(): void {
  }

  onClick() {
    this.btnclick.emit();
  }
}
