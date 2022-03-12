import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockMainInfoComponent } from './stock-main-info.component';

describe('StockMainInfoComponent', () => {
  let component: StockMainInfoComponent;
  let fixture: ComponentFixture<StockMainInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockMainInfoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockMainInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
