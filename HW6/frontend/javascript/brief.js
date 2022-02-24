import { template, content, identity } from "./content.js";
import { trime } from "./utils.js";

const brief_format = template`
<div id="brief_layout">
  <img id="logo" src=\'${"brief.logo"}\' style="width:128px; height:128px;"/>

  <ul class="my_info_list" style="height: 50%;">
    <li>
      <div class="key">Company Name</div>
      <div class="value">${"brief.name"}</div>
    </li>

    <li>
      <div class="key">Stock Ticker Symbol</div>
      <div class="value">${"brief.ticker"}</div>
    </li>

    <li>
      <div class="key">Stock Exchange Code</div>
      <div class="value">${"brief.exchange"}</div>
    </li>

    <li>
      <div class="key">Company IPO Date</div>
      <div class="value">${"brief.ipo"}</div>
    </li>

    <li>
      <div class="key">Category</div>
      <div class="value">${"brief.finnhubIndustry"}</div>
    </li>
  </ul>
  </div>
</div>`;

export default class brief_content extends content {
  constructor(main = null, DOM_id = "", name = "") {
    super(main, DOM_id, name);
    this.required = {
      logo: identity,
      name: identity,
      ticker: identity,
      exchange: trime(30),
      ipo: identity,
      finnhubIndustry: identity,
    };
  }

  async show_content(element) {
    await this.wait_for_ready();

    element.style = "";
    let content = brief_format(this.main.data);
    element.innerHTML = content;
  }
}
