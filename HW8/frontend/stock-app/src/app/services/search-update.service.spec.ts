import { TestBed } from '@angular/core/testing';

import { SearchUpdateService } from './search-update.service';

describe('SearchUpdateService', () => {
  let service: SearchUpdateService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(SearchUpdateService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
