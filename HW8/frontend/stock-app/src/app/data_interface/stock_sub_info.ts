import { stringify } from '@angular/compiler/src/util';

export interface Price_Summary {
  h: number;
  l: number;
  o: number;
  pc: number;
}

export interface About_Info {
  ipo: string;
  finnhubIndustry: string;
  weburl: string;
  peers: string[];
}

export interface Hourly_Price_Record {
  c: number[];
  t: number[];
}

export interface Summary_Info {
  price_info: Price_Summary;
  about: About_Info;
  hourly_record: Hourly_Price_Record;
}

export interface News {
  source: string;
  datetime: number;
  headline: string;
  summary: string;
  url: string;
  image: string;
  trim_header?: string;
}

export interface Historical_Record {
  c: number[];
  h: number[];
  l: number[];
  o: number[];
  t: number[];
  v: number[];
}

export interface Recommend_Info {
  buy: number;
  hold: number;
  period: string;
  sell: number;
  strongBuy: number;
  strongSell: number;
  symbol: string;
}

export interface Earning_Info {
  actual: number;
  estimate: number;
  period: string;
  surprise: number;
  surprisePercent: number;
  symbol: string;
}

export interface Social_Sentiment {
  atTime: string;
  mention: number;
  positiveScore: number;
  negativeScore: number;
  positiveMention: number;
  negativeMention: number;
  score: number;
}


export interface Social_Sentiment_List {
  reddit: Social_Sentiment[];
  twitter: Social_Sentiment[];
}

export interface Sentiments_For_Plot {
  total_mention: number;
  positive: number;
  negative: number;
}

export interface Insights_Info {
  social_sentiments: {reddit: Sentiments_For_Plot; twitter: Sentiments_For_Plot, name: string};
  recommends: Recommend_Info[];
  earnings: Earning_Info[];
}
