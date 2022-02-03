import {template, content} from "./content.js"

const brief_format = template`
<div id="brief_layout">
  <img src=\'${'brief.logo'}\' alt=${'brief.name'} icon />

  <ul class="my_info_list">
    <li>
      <div class="key">Company Name</div>
      <div class="value">${'brief.name'}</div>
    </li>

    <li>
      <div class="key">Stock Ticker Symbol</div>
      <div class="value">${'brief.ticker'}</div>
    </li>

    <li>
      <div class="key">Stock Exchange Code</div>
      <div class="value">${'brief.exchange'}</div>
    </li>

    <li>
      <div class="key">Company IPO Date</div>
      <div class="value">${'brief.ipo'}</div>
    </li>

    <li>
      <div class="key">Category</div>
      <div class="value">${'brief.finnhubIndustry'}</div>
    </li>
  </ul>
  </div>
</div>`;

export default class brief_content extends content {
  show_content() {
    if(Object.keys(this.main.data).length == 0) return "";
    return brief_format(this.main.data);
  }
}