import { template, content, identity } from "./content.js";
import { dateFormat, FAILED } from "./utils.js";

const arrow_imgs = {
  upward: "/frontend/img/GreenArrowUp.png",
  downward: "/frontend/img/RedArrowDown.png",
};

const summary_format = template`
<div id="summary_content">
  <ul class="my_info_list" style="height: 65%;">
    <li>
      <div class="key">Stock Ticker Symbol</div>
      <div class="value">${"symbol"}</div>
    </li>

    <li>
      <div class="key">Trading Day</div>
      <div class="value">${"t"}</div>
    </li>

    <li>
      <div class="key">Previous Closing Price</div>
      <div class="value">${"pc"}</div>
    </li>

    <li>
      <div class="key">Opening Price</div>
      <div class="value">${"o"}</div>
    </li>

    <li>
      <div class="key">High Price</div>
      <div class="value">${"h"}</div>
    </li>

    <li>
      <div class="key">Low Price</div>
      <div class="value">${"l"}</div>
    </li>

    <li>
      <div class="key">Change</div>
      <div class="value">${"d"}<img class ="arrow_img" src=${"d_arrow"}></div>
    </li>

    <li>
      <div class="key">Change Percent</div>
      <div class="value">${"dp"}<img class ="arrow_img" src=${"dp_arrow"}></div>
    </li>
  </ul>

  <div class="recommend_list">
    <p style="color: #ed2837;">Strong Sell</p>

    <ul>
      <li>${"strongSell"}</li>

      <li>${"sell"}</li>

      <li>${"hold"}</li>

      <li>${"buy"}</li>

      <li>${"strongBuy"}</li>
    </ul>

    <p style="color : #00ff7f;">Strong Buy</p>
  </div>

  <p class="list_slogan">
    Recommendation Trends
  </p>
</div>`;

export default class summary_content extends content {
  constructor(main = null, DOM_id = "", name = "") {
    super(main, DOM_id, name);
    this.required = {
      t: (timestamp) => dateFormat(new Date(timestamp * 1000), "d mmmm, yyyy"),
      pc: identity,
      o: identity,
      h: identity,
      l: identity,
      d: identity,
      dp: identity,
      strongSell: identity,
      sell: identity,
      hold: identity,
      buy: identity,
      strongBuy: identity,
      symbol: identity,
    };
  }

  process_data(data) {
    if (this.main.STATUS == FAILED || data.hasOwnProperty("Error")) {
      super.process_data(data);
    } else {
      const new_data = { ...data["summary"], ...data["recommend"] };
      super.process_data(new_data);
    }

    if (this.main.current_btn == this) this.main.render();
  }

  get_arrow(change) {
    if(change == 0 || change == undefined) {
      return "";
    }else if(change > 0) {
      return arrow_imgs["upward"];
    }else{
      return arrow_imgs["downward"];
    }

    return 
  }

  async show_content(element) {
    await this.wait_for_ready();

    element.style = "";

    const combined_data = {
      ...this.main.data.summary,
      d_arrow: this.get_arrow(this.main.data.summary.d),
      dp_arrow: this.get_arrow(this.main.data.summary.dp),
    };

    let content = summary_format(combined_data);

    element.innerHTML = content;
  }
}
