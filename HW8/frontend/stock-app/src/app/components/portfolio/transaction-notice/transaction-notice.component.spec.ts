import { ComponentFixture, TestBed } from '@angular/core/testing';

import { TransactionNoticeComponent } from './transaction-notice.component';

describe('TransactionNoticeComponent', () => {
  let component: TransactionNoticeComponent;
  let fixture: ComponentFixture<TransactionNoticeComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ TransactionNoticeComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(TransactionNoticeComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
