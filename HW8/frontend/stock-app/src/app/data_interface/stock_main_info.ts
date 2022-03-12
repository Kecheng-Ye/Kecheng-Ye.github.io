export interface stock_name_block {
  ticker: string;
  name: string;
  exchange: string;
}

export interface stock_img {
  logo: string;
}

export interface stock_price {
  c: number;
  d: number;
  t: number;
  dp: number;
}

export interface stock_main_info {
  ticker: string;
  name: string;
  exchange: string;
  logo: string;
  c: number;
  d: number;
  t: number;
  dp: number;
}
