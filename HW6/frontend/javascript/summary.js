import {template, content} from "./content.js"

const arrow_imgs = {"upward" : "./img/GreenArrowUp.png", "downward" : "./img/RedArrowDown.png"}

const summary_format = template`
<div id="summary_content">
  <ul class="my_info_list" style="height: 65%;">
    <li>
      <div class="key">Stock Ticker Symbol</div>
      <div class="value">${'stock_name'}</div>
    </li>

    <li>
      <div class="key">Trading Day</div>
      <div class="value">${'t'}</div>
    </li>

    <li>
      <div class="key">Previous Closing Price</div>
      <div class="value">${'pc'}</div>
    </li>

    <li>
      <div class="key">Opening Price</div>
      <div class="value">${'o'}</div>
    </li>

    <li>
      <div class="key">High Price</div>
      <div class="value">${'h'}</div>
    </li>

    <li>
      <div class="key">Low Price</div>
      <div class="value">${'l'}</div>
    </li>

    <li>
      <div class="key">Change</div>
      <div class="value">${'d'}<img class ="arrow_img" src=${'d_arrow'}></div>
    </li>

    <li>
      <div class="key">Change Percent</div>
      <div class="value">${'dp'}<img class ="arrow_img" src=${'dp_arrow'}></div>
    </li>
  </ul>

  <div class="recommend_list">
    <p style="color: #ed2837;">Strong Sell</p>

    <ul>
      <li>${'strongSell'}</li>

      <li>${'sell'}</li>

      <li>${'hold'}</li>

      <li>${'buy'}</li>

      <li>${'strongBuy'}</li>
    </ul>

    <p style="color : #00ff7f;">Strong Buy</p>
  </div>

  <p class="list_slogan">
    Recommendation Trends
  </p>
</div>`;


export default class summary_content extends content {
  show_content() {
    const combined_data = {
      ...this.main.data.summary, 
      ...this.main.data.recommend,
      d_arrow : (this.main.data.summary.d >= 0) ? arrow_imgs["upward"] : arrow_imgs["downward"],
      dp_arrow : (this.main.data.summary.dp >= 0) ? arrow_imgs["upward"] : arrow_imgs["downward"],
      stock_name :this.main.data.brief.ticker
    }

    console.log(combined_data)

    return summary_format(combined_data);
  }
}
