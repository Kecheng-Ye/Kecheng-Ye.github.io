import {
  query,
  template,
  identity,
  SUCCESS,
  FAILED,
  PENDING,
} from "./utils.js";

class content {
  constructor(main = null, DOM_id = "", name = "") {
    this.main = main;
    this.id = DOM_id;
    this.name = name;
    this.required = {};
    this.isReady = false;
  }

  process_data(data) {
    if (this.main.STATUS == FAILED || data.hasOwnProperty("Error")) {
      this.main.data[this.id] = {};
      this.main.STATUS = FAILED;
    } else {
      let result_data = {};
      Object.keys(this.required).forEach((element) => {
        result_data[element] = this.required[element](data[element]);
      });

      this.main.data[this.id] = result_data;
      this.main.STATUS = SUCCESS;
    }

    this.isReady = true;
    if(this.main.current_btn == this) this.main.render();
  }

  async wait_for_ready() {
    var start_time = new Date().getTime()
  
    while (true) {
      if (this.isReady) {
        console.log(this.id + " data is ready");
        break; // or return
      }
      if (new Date() > start_time + 3000) {
        console.log(this.id + " get data failed");
        break; // or throw
      }
      await new Promise(resolve => setTimeout(resolve, 1000));
    }
  }

  async show_content(element) {
    await this.wait_for_ready();
    return null;
  }
}

export { template, content, query, identity, SUCCESS, FAILED};
