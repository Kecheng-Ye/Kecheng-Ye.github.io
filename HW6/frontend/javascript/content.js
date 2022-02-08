import {query, template, identity, SUCCESS, FAILED, PENDING} from "./utils.js";

class content {

  constructor(main = null, DOM_id = "", name = "") {
    this.main = main
    this.id = DOM_id
    this.name = name
    this.required = {}
    this.isReady = false;
  }

  process_data(data) {
    if(this.main.STATUS == FAILED || data.hasOwnProperty("Error")) {
      this.main.data[this.id] = {}
      this.main.STATUS = FAILED;
    }else{
      let result_data = {}
      Object.keys(this.required).forEach(element => {
        result_data[element] = this.required[element](data[element])
      });

      this.main.data[this.id] = result_data
      this.main.STATUS = SUCCESS
    }

    this.isReady = true;
    if(this.main.current_btn == this) this.main.render();
  }

  show_content() {
    return null;
  }
}

export {template, content, query, identity}