import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockMainInfoNameComponent } from './stock-main-info-name.component';

describe('StockMainInfoNameComponent', () => {
  let component: StockMainInfoNameComponent;
  let fixture: ComponentFixture<StockMainInfoNameComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockMainInfoNameComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockMainInfoNameComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
