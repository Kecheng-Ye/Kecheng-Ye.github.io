import template from "./template.js";

class content {

  constructor(main = null, DOM_id = "") {
    this.main = main
    this.id = DOM_id
  }

  show_content() {
    return "";
  }
}

export {template, content}