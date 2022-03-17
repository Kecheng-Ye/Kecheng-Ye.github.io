import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoSummaryAboutComponent } from './stock-sub-info-summary-about.component';

describe('StockSubInfoSummaryAboutComponent', () => {
  let component: StockSubInfoSummaryAboutComponent;
  let fixture: ComponentFixture<StockSubInfoSummaryAboutComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoSummaryAboutComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoSummaryAboutComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
