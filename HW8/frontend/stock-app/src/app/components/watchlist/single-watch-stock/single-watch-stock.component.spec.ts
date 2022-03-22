import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SingleWatchStockComponent } from './single-watch-stock.component';

describe('SingleWatchStockComponent', () => {
  let component: SingleWatchStockComponent;
  let fixture: ComponentFixture<SingleWatchStockComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SingleWatchStockComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SingleWatchStockComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
