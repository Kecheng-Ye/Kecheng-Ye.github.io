export interface Suggestion {
  description: string;
  displaySymbol: string;
  symbol: string;
  type: string;
}

export interface Suggestion_query {
  count: number;
  result: Suggestion[];
}
