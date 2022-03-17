import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoSummaryPriceComponent } from './stock-sub-info-summary-price.component';

describe('StockSubInfoSummaryPriceComponent', () => {
  let component: StockSubInfoSummaryPriceComponent;
  let fixture: ComponentFixture<StockSubInfoSummaryPriceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoSummaryPriceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoSummaryPriceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
