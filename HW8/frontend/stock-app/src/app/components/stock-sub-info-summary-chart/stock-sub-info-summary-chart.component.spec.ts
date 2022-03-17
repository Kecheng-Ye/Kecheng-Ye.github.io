import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoSummaryChartComponent } from './stock-sub-info-summary-chart.component';

describe('StockSubInfoSummaryChartComponent', () => {
  let component: StockSubInfoSummaryChartComponent;
  let fixture: ComponentFixture<StockSubInfoSummaryChartComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoSummaryChartComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoSummaryChartComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
