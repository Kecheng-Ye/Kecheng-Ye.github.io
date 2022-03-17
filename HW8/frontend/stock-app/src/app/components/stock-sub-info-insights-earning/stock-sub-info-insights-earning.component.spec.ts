import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoInsightsEarningComponent } from './stock-sub-info-insights-earning.component';

describe('StockSubInfoInsightsEarningComponent', () => {
  let component: StockSubInfoInsightsEarningComponent;
  let fixture: ComponentFixture<StockSubInfoInsightsEarningComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoInsightsEarningComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoInsightsEarningComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
