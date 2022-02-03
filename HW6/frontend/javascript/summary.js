import {template, content} from "./content.js"

const summary_format = "summary";

export default class summary_content extends content {
  show_content() {
    return summary_format;
  }
}
