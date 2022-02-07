import brief_content from "./brief.js"
import news_content from "./news.js"
import charts_content from "./charts.js"
import summary_content from "./summary.js"
import {SUCCESS, FAILED, PENDING, query, createRequest} from "./utils.js"

class main_content {
  constructor(DOM_id = "") {
    this.id = DOM_id;
    this.data = {};
    this.buttons = {
      brief   : new brief_content(this, "brief"),
      summary : new summary_content(this, "summary"),
      // charts  : new charts_content(this, "chart"),
      // news    : new news_content(this, "news")              
    };
    
    // defaultly we are on the Company section
    this.current_btn = this.buttons.brief;
    this.STATUS = PENDING;
  }

  reset() {
    main.STATUS = PENDING;
    for (let [ _, value] of Object.entries(this.buttons)) {
      value.isReady = false;
    }
  }

  render() {
    var content_section = document.getElementById("content");
    if(this.STATUS == FAILED) {
      this.render_fail(content_section);
    }else if(this.STATUS == SUCCESS) {
      this.render_success(content_section);
    }else{
      alert("Error when rendering");
    }
  }

  render_fail(content) {
    var newElement = document.createElement('div');
    newElement.classList.add("fail_notice");
    newElement.innerHTML = '<p>Error: No record has been found, please enter a valid symbol</p>';
    content.appendChild(newElement);
  }

  render_success(content) {
    var button_lst = document.createElement('ul');
    button_lst.classList.add("section_navi");
    this.register_buttons(button_lst);
    button_lst.classList.add("section_navi");
    content.appendChild(button_lst);
    
    var main_content = document.createElement('div');
    main_content.id = "main_content";
    content.appendChild(main_content);
    this.content_generator(this.current_btn)();
  }

  register_buttons(button_lst) {
    for (let [ _, value] of Object.entries(this.buttons)) {
      let new_button = document.createElement('li');
      new_button.innerHTML = `<button type="button" id="${value.id}">Company</button>`;
      new_button.onclick = this.content_generator(value);
      button_lst.appendChild(new_button);
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

  do_query(stock_name) {
    this.reset();
  
    for (let [ _, value] of Object.entries(this.buttons)) {
      createRequest(query({"stock" : stock_name, "sec" : value.id}), value.process_data.bind(value));
    }
  }
}

var main = new main_content("main_content");

main.do_query("TSLA");

