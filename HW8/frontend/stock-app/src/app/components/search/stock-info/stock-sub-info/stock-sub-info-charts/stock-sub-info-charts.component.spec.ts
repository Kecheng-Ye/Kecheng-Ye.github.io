import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoChartsComponent } from './stock-sub-info-charts.component';

describe('StockSubInfoChartsComponent', () => {
  let component: StockSubInfoChartsComponent;
  let fixture: ComponentFixture<StockSubInfoChartsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoChartsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoChartsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
