import { transaction } from './portfolio';

export interface stock_name_block {
  ticker: string;
  name: string;
  exchange: string;
  is_in_watch_list: boolean;
  transaction_rec: [number, transaction[]];
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
  name: stock_name_block;
  img: stock_img;
  price: stock_price;
  is_market_open: boolean;
  market_time: string;
  balance: number;
}

export interface Company_Brief {
  country: string;
  currency: string;
  exchange: string;
  finnhubIndustry: string;
  ipo: string;
  logo: string;
  marketCapitalization: number;
  name: string;
  phone: string;
  shareOutstanding: number;
  ticker: string;
  weburl: string;
}

export interface Cur_Price {
  c: number;
  d: number;
  dp: number;
  h: number;
  l: number;
  o: number;
  pc: number;
  t: number;
}
