import { ComponentFixture, TestBed } from '@angular/core/testing';

import { NaviSearchButtonComponent } from './navi-search-button.component';

describe('NaviSearchButtonComponent', () => {
  let component: NaviSearchButtonComponent;
  let fixture: ComponentFixture<NaviSearchButtonComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ NaviSearchButtonComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(NaviSearchButtonComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
