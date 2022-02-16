import brief_content from "./brief.js";
import news_content from "./news.js";
import charts_content from "./charts.js";
import summary_content from "./summary.js";
import search_bar from "./search_bar.js";
import { SUCCESS, FAILED, PENDING, query, createRequest } from "./utils.js";

class main_content {
  constructor(DOM_id = "") {
    this.id = DOM_id;
    this.data = {};
    this.buttons = {
      brief: new brief_content(this, "brief", "Company"),
      summary: new summary_content(this, "summary", "Stock Summary"),
      charts: new charts_content(this, "charts", "Charts"),
      news: new news_content(this, "news", "Latest News"),
    };

    // defaultly we are on the Company section
    this.current_btn = this.buttons.brief;
    this.STATUS = PENDING;
    this.query = "";
  }

  reset() {
    var content_section = document.getElementById("content");
    content_section.innerHTML = "";
    main.STATUS = PENDING;
    this.query = "";

    for (let [_, value] of Object.entries(this.buttons)) {
      value.isReady = false;
    }
  }

  render() {
    var content_section = document.getElementById("content");
    content_section.innerHTML = "";

    if (this.STATUS == FAILED) {
      this.render_fail(content_section);
    } else if (this.STATUS == SUCCESS) {
      this.render_success(content_section);
    } else {
      alert("Error when rendering");
    }
  }

  render_fail(content) {
    var newElement = document.createElement("div");
    newElement.classList.add("fail_notice");
    newElement.innerHTML =
      "<p>Error: No record has been found, please enter a valid symbol</p>";
    content.appendChild(newElement);
  }

  render_success(content) {
    var button_lst = document.createElement("ul");
    button_lst.classList.add("section_navi");
    this.register_buttons(button_lst);
    content.appendChild(button_lst);

    var main_content = document.createElement("div");
    main_content.id = "main_content";
    content.appendChild(main_content);
    this.content_generator(this.current_btn)();
  }

  register_buttons(button_lst) {
    for (let [_, value] of Object.entries(this.buttons)) {
      let new_button = document.createElement("li");
      new_button.innerHTML = `<button type="button" id="${value.id}">${value.name}</button>`;
      new_button.onclick = this.content_generator(value);
      button_lst.appendChild(new_button);
    }
  }

  refresh_button(new_btn) {
    if (this.current_btn !== null) {
      document
        .getElementById(this.current_btn.id)
        .parentElement.classList.remove("active");
    }

    document.getElementById(new_btn.id).parentElement.classList.add("active");

    this.current_btn = new_btn;
  }

  content_generator = (cnt) => () => {
    this.refresh_button(cnt);
    var content = document.getElementById(this.id);
    content.innerHTML = "";
    cnt.show_content(content);
  };

  do_query(stock_name) {
    this.reset();
    this.query = stock_name;

    for (let [_, value] of Object.entries(this.buttons)) {
      createRequest(
        query({ stock: stock_name, sec: value.id }),
        value.process_data.bind(value)
      );
    }
  }
}

var main = new main_content("main_content");
var bar = new search_bar(document.getElementById("search"), main);

window.addEventListener("resize", function (event) {
  bar.render();
});

bar.input_field.addEventListener('keypress', function (e) {
  if (e.key === 'Enter') {
    bar.search();
  }
});

