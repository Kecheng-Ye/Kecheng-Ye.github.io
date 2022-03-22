import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SellingModalComponent } from './selling-modal.component';

describe('SellingModalComponent', () => {
  let component: SellingModalComponent;
  let fixture: ComponentFixture<SellingModalComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SellingModalComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SellingModalComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
