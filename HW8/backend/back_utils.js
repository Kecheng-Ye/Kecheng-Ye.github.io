import * as util from "../util.js";

export const API_KEY = "c7qumeiad3ia6nr4tkfg";
export const ERROR = { Error: "error" };

// brief constant
export const brief_req = util.template`https://finnhub.io/api/v1/stock/profile2?symbol=${"stock"}&token=${"token"}`;

// summary constant
export const price_req = util.template`https://finnhub.io/api/v1/quote?symbol=${"stock"}&token=${"token"}`;

// Recommendation trend constant
export const recommend_req = util.template`https://finnhub.io/api/v1/stock/recommendation?symbol=${"stock"}&token=${"token"}`;

// Stock charts
export const charts_req = util.template`https://finnhub.io/api/v1/stock/candle?symbol=${"stock"}&resolution=${"resolution"}&from=${"start"}&to=${"end"}&token=${"token"}`;

// Stock news
export const news_req = util.template`https://finnhub.io/api/v1/company-news?symbol=${"stock"}&from=${"start"}&to=${"end"}&token=${"token"}`;

// Autocomplete
export const autocomplete_req = util.template`https://finnhub.io/api/v1/search?q=${"stock"}&token=${"token"}`;

// Peers
export const peers_req = util.template`https://finnhub.io/api/v1/stock/peers?symbol=${"stock"}&token=${"token"}`;

// Social Sentiments
export const social_req = util.template`https://finnhub.io/api/v1/stock/social-sentiment?symbol=${"stock"}&from=2022-01-01&token=${"token"}`;

// Earnings
export const earning_req = util.template`https://finnhub.io/api/v1/stock/earnings?symbol=${"stock"}&token=${"token"}
`;