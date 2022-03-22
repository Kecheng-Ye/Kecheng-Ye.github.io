import { ComponentFixture, TestBed } from '@angular/core/testing';

import { SinglePortfolioRecordComponent } from './single-portfolio-record.component';

describe('SinglePortfolioRecordComponent', () => {
  let component: SinglePortfolioRecordComponent;
  let fixture: ComponentFixture<SinglePortfolioRecordComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SinglePortfolioRecordComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SinglePortfolioRecordComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
