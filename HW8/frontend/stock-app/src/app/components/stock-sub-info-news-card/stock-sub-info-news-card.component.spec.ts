import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoNewsCardComponent } from './stock-sub-info-news-card.component';

describe('StockSubInfoNewsCardComponent', () => {
  let component: StockSubInfoNewsCardComponent;
  let fixture: ComponentFixture<StockSubInfoNewsCardComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoNewsCardComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoNewsCardComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
