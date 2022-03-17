import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoInsightsRecommendsComponent } from './stock-sub-info-insights-recommends.component';

describe('StockSubInfoInsightsRecommendsComponent', () => {
  let component: StockSubInfoInsightsRecommendsComponent;
  let fixture: ComponentFixture<StockSubInfoInsightsRecommendsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoInsightsRecommendsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoInsightsRecommendsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
