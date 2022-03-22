export interface transaction {
  price: number;
  shares: number;
}

export interface buying_info {
  name: string;
  price: number;
}

export interface selling_info {
  name: string;
  price: number;
  shares_remain: number;
}

export interface one_portfolio_entry {
  ticker: string;
  name: string;
  c: number;
  d: number;
  record: [number, transaction[]];
  index: number;
  total_cost: number;
  avg_cost: number;
  change: number;
  market_val: number;
  color: string;
}
