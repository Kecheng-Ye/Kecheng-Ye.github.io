import charts_content from "./charts.js";
import { template, content, identity, SUCCESS, FAILED } from "./content.js";
import { dateFormat } from "./utils.js";

const news_format = template`
  <div class="news_logo">
    <img src="${"image"}", width="75px", height="75px">
  </div>

  <div class="news_content">
    <p class="title">
      ${"headline"}
    </p>

    <p class="content">
      ${"datetime"}
    </p>

    <a class="link" href="${"url"}" target="_blank">See Original Post</a>
  </div>`;

export default class news_content extends content {
  constructor(main = null, DOM_id = "", name = "") {
    super(main, DOM_id, name);
    this.required = {
      image: identity,
      headline: identity,
      url: identity,
      datetime: (timestamp) =>
        dateFormat(new Date(timestamp * 1000), "d mmmm, yyyy"),
    };
  }

  process_data(data) {
    if (this.main.STATUS == FAILED || data.hasOwnProperty("Error")) {
      this.main.data[this.id] = {};
      this.main.STATUS = FAILED;
    } else {
      let result = [];
      let count = 0;
      for (var i = 0; i < data.length && count < 5; i++) {
        let one_news = {};
        let success = true;
        Object.keys(this.required).forEach((element) => {
          if(!(data[i].hasOwnProperty(element)) || data[i][element].length == 0) {
            success = false;
          }

          if(!success) return;

          one_news[element] = this.required[element](data[i][element]);
        });
        
        if(success) {
          result.push(one_news);
          count++;
        }
      }

      this.main.data[this.id] = result;
      this.main.STATUS = SUCCESS;
    }

    this.isReady = true;
    if (this.main.current_btn == this) this.main.render();
  }

  async show_content(element) {
    await this.wait_for_ready();

    var news = document.createElement("div");
    news.id = "news";
    var list = document.createElement("ul");
    list.id = "news_lst";
    news.appendChild(list);

    for (var i = 0; i < this.main.data.news.length; i++) {
      let one_news = document.createElement("li");
      one_news.innerHTML = news_format(this.main.data.news[i]);
      list.appendChild(one_news);
    }

    element.appendChild(news);
    element.style = "margin-top: 20px;";
  }
}
