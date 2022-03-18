import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoNewsComponent } from './stock-sub-info-news.component';

describe('StockSubInfoNewsComponent', () => {
  let component: StockSubInfoNewsComponent;
  let fixture: ComponentFixture<StockSubInfoNewsComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoNewsComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoNewsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
