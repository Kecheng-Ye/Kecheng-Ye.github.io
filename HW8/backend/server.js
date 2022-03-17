import { identity } from "../util.js";
import * as back_util from "./back_utils.js";
import {
  base_req,
  base_req_lst,
  stock_history_request,
  stock_news_request,
} from "./request.js";

// {entry_point: request}
const api_list = {
  "/brief/:stock": new base_req(back_util.brief_req),
  "/price/:stock": new base_req(back_util.price_req),
  "/hour-charts/:stock": new stock_history_request(back_util.charts_req, {
    resolution: "5",
    hours: 6,
  }),
  "/historical-charts/:stock": new stock_history_request(back_util.charts_req, {
    resolution: "D",
    years: 2,
  }),
  "/news/:stock": new stock_news_request(back_util.news_req),
  "/autocomplete/:stock": new base_req(back_util.autocomplete_req),
  "/peers/:stock": new base_req(back_util.peers_req),
  "/social-sentiments/:stock": new base_req(back_util.social_req),
  "/earnings/:stock": new base_req(back_util.earning_req),
  "/recommend/:stock": new base_req(back_util.recommend_req),
  // "/summary/:stock": new base_req_lst(
  //   new base_req(back_util.summary_req),
  //   new base_req(back_util.recommend_req, (lst) => lst[0])
  // ),
};

export class api {
  constructor(app, name) {
    this.name = name;
    this.app = app;

    this.register(api_list);
  }

  register(lst) {
    Object.keys(lst).forEach((key) => {
      lst[key].register(this.app, this.name + key);
    });
  }
}
