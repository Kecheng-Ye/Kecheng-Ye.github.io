import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NaviButtonComponent } from './navi-button.component';

describe('NaviButtonComponent', () => {
  let component: NaviButtonComponent;
  let fixture: ComponentFixture<NaviButtonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NaviButtonComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NaviButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
