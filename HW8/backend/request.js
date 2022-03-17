import { identity, fetch_and_process } from "../util.js";
import { API_KEY } from "./back_utils.js";
import moment from "moment";
import { logger } from "./logger.js";

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
      logger.info("Get request at " + req.url);
      const result = await this.fetch_data(req);
      if (Object.keys(result).length == 0) {
        logger.info("Requst at " + req.url + " failed");
        res.status(404).send(result);
        return;
      }
      logger.info("Requst at " + req.url + " succeed");
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
    let results = {};
    let meet_error = true;

    for (const req of this.requests) {
      const one_result = await req.fetch_data(request);
      if (Object.keys(one_result).length != 0) {
        meet_error = false;
        results = { ...results, ...one_result };
      }
    }

    return results;
  }
}

export class stock_history_request extends base_req {
  constructor(request_format, {resolution='D', years=0, months=0, days=0, hours=0}) {
    super(request_format);
    this.resolution = resolution;
    this.years = years;
    this.months = months;
    this.days = days;
    this.hours = hours;
  }

  async fetch_data(request) {
    const ticker = request.params.stock;
    const start_timestamp = parseInt(request.query.start);
    const end = moment.unix(start_timestamp);
    const start = moment
      .unix(start_timestamp)
      .subtract(this.years, "years")
      .subtract(this.months, "months")
      .subtract(this.days, "days")
      .subtract(this.hours, "hours");

    const result = await fetch_and_process(
      this.request_format({
        stock: ticker,
        resolution: this.resolution,
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

    return result;
  }
}
