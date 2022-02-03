import brief_content from "./brief.js"
import news_content from "./news.js"
import charts_content from "./charts.js"
import summary_content from "./summary.js"
let query = "http://127.0.0.1:5000/query?stock_name=TSLA"

const temp_data = {
  "brief": {
      "exchange": "NASDAQ NMS - GLOBAL MARKET",
      "finnhubIndustry": "Automobiles",
      "ipo": "2010-06-09",
      "logo": "https://finnhub.io/api/logo?symbol=TSLA",
      "name": "Tesla Inc",
      "ticker": "TSLA"
  },
  "summary": {
      "d": -25.59,
      "dp": -2.7479,
      "h": 931.4999,
      "l": 889.47,
      "o": 928.18,
      "pc": 931.25,
      "t": "02 February, 2022"
  },
  "recommend": {
      "buy": 11,
      "hold": 13,
      "sell": 7,
      "strongBuy": 13,
      "strongSell": 4
  }
}

class main_content {
  constructor(DOM_id = "") {
    this.id = DOM_id;
    this.data = temp_data;
    this.buttons = {
      brief   : new brief_content(this, "brief"),
      summary : new summary_content(this, "summary"),
      charts  : new charts_content(this, "chart"),
      news    : new news_content(this, "news")              
    };
    this.current_btn = null;
    this.register_buttons();
    // defaultly we are on the Company section
    this.content_generator(this.buttons.brief)();
  }

  register_buttons() {
    for (let [ _, value] of Object.entries(this.buttons)) {
      document.getElementById(value.id).onclick = this.content_generator(value);
    }
  }

  refresh_button(new_btn) {
    if(this.current_btn !== null) {
      document.getElementById(this.current_btn.id).parentElement.classList.remove('active');
    }

    document.getElementById(new_btn.id).parentElement.classList.add('active');

    this.current_btn = new_btn;
  }

  content_generator = cnt => () => {
    this.refresh_button(cnt)
    document.getElementById(this.id).innerHTML = cnt.show_content();
  }

  refresh_all(new_data) {
    this.data = new_data
    this.content_generator(this.current_btn)()
  }
}

var main = new main_content("main_content")


function createCORSRequest(method, url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function() { 
    if (xhr.readyState == 4 && xhr.status == 200)
        callback(JSON.parse(xhr.responseText));
  }
  xhr.open(method, url, true);
  xhr.send(null)
  return xhr;
}

// setTimeout(() => {
//   createCORSRequest('GET', query, main.refresh_all.bind(main))
// }, 1000)