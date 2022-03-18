import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockMainInfoPriceComponent } from './stock-main-info-price.component';

describe('StockMainInfoPriceComponent', () => {
  let component: StockMainInfoPriceComponent;
  let fixture: ComponentFixture<StockMainInfoPriceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockMainInfoPriceComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockMainInfoPriceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
