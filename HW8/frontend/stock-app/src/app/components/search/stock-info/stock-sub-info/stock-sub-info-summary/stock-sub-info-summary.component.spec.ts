import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoSummaryComponent } from './stock-sub-info-summary.component';

describe('StockSubInfoSummaryComponent', () => {
  let component: StockSubInfoSummaryComponent;
  let fixture: ComponentFixture<StockSubInfoSummaryComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoSummaryComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoSummaryComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
