import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoInsightsComponent } from './stock-sub-info-insights.component';

describe('StockSubInfoInsightsComponent', () => {
  let component: StockSubInfoInsightsComponent;
  let fixture: ComponentFixture<StockSubInfoInsightsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoInsightsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoInsightsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
