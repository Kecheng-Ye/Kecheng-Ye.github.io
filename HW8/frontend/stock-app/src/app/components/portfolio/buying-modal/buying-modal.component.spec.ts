import { ComponentFixture, TestBed } from '@angular/core/testing';

import { BuyingModalComponent } from './buying-modal.component';

describe('BuyingModalComponent', () => {
  let component: BuyingModalComponent;
  let fixture: ComponentFixture<BuyingModalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ BuyingModalComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(BuyingModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
