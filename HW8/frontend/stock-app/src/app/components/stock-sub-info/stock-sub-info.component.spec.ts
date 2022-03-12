import { ComponentFixture, TestBed } from '@angular/core/testing';

import { StockSubInfoComponent } from './stock-sub-info.component';

describe('StockSubInfoComponent', () => {
  let component: StockSubInfoComponent;
  let fixture: ComponentFixture<StockSubInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ StockSubInfoComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(StockSubInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
