import { TestBed } from '@angular/core/testing';

import { PreviousStateService } from './previous-state.service';

describe('PreviousStateService', () => {
  let service: PreviousStateService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(PreviousStateService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
