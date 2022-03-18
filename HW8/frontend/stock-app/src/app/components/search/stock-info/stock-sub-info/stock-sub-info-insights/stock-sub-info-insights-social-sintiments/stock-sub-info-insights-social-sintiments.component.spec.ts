import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoInsightsSocialSintimentsComponent } from './stock-sub-info-insights-social-sintiments.component';

describe('StockSubInfoInsightsSocialSintimentsComponent', () => {
  let component: StockSubInfoInsightsSocialSintimentsComponent;
  let fixture: ComponentFixture<StockSubInfoInsightsSocialSintimentsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoInsightsSocialSintimentsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoInsightsSocialSintimentsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
