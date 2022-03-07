import { identity, fetch_and_process } from "../util.js";
import { API_KEY } from "./back_utils.js";
import moment from "moment";

export class base_req {
  constructor(request_format, post_process = identity) {
    this.request_format = request_format;
    this.post_process = post_process;
  }

  async fetch_data(request) {
    const ticker = request.params.stock;
    const result = await fetch_and_process(
      this.request_format({ stock: ticker, token: API_KEY }),
      this.post_process
    );
    
    return result;
  }

  register(app, query_entry) {
    app.get(query_entry, async (req, res) => {
      const result = await this.fetch_data(req);
      if (Object.keys(result).length == 0) {
        res.status(404);
      }
  
      res.send(result);
    });
  }
}

export class base_req_lst extends base_req {
  constructor(...requests) {
    super("lst");
    this.requests = requests;
  }

  async fetch_data(request) {

    const ticker = request.params.stock;
    let results = {};
    let meet_error = true;

    for (const req of this.requests) {
      const one_result = await req.fetch_data(request);
      if(Object.keys(one_result).length != 0) {
        meet_error = false;
        results = {...results, ...one_result};
      }
    }

    return results
  }
}

export class stock_history_request extends base_req {
  async fetch_data(request) {
    const end = moment();
    const start = moment().subtract(6, "months").subtract(1, "days");
    const ticker = request.params.stock;

    const result = await fetch_and_process(
      this.request_format({
        stock: ticker,
        start: start.format("X"),
        end: end.format("X"),
        token: API_KEY,
      }),
      this.post_process
    );

    return result;
  }
}

export class stock_news_request extends base_req {
  async fetch_data(request) {
    const end = moment();
    const start = moment().subtract(30, "days");
    const ticker = request.params.stock;

    const result = await fetch_and_process(
      this.request_format({
        stock: ticker,
        start: start.format("YYYY-MM-DD"),
        end: end.format("YYYY-MM-DD"),
        token: API_KEY,
      }),
      this.post_process
    );

    return result;;
  }
}
