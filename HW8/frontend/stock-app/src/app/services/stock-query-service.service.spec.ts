import { TestBed } from '@angular/core/testing';

import { StockQueryServiceService } from './stock-query-service.service';

describe('StockQueryServiceService', () => {
  let service: StockQueryServiceService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(StockQueryServiceService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
