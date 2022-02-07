import {template, content, identity} from "./content.js"

const charts_format = "charts";

export default class charts_content extends content {
  show_content() {
    return charts_format;
  }
}