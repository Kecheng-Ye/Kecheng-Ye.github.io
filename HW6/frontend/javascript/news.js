import {template, content, identity} from "./content.js"

const news_format = "news";

export default class news_content extends content {
  show_content() {
    return news_format;
  }
}
