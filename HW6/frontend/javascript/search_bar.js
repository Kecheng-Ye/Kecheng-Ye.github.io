
export default class search_bar {
  constructor(element, main) {
    this.main = main;
    this.ele = element;

    this.title = document.createElement('p');
    this.title.innerHTML = 'Stock Search';

    this.bar = document.createElement('p');
    this.bar.id = "search_box";
    
    this.search_icon = document.createElement('img');
    this.search_icon.src = Flask.url_for("static", {"filename" :'./img/search-solid.svg'});
    this.search_icon.style = "float: left; margin-left : 0.5%;";
    this.search_icon.onclick = this.search.bind(this);
    this.bar.appendChild(this.search_icon);
    
    this.input_field = document.createElement('input');
    this.input_field.type = "text";
    this.input_field.placeholder = "Enter Stock Ticker Symbol";
    this.input_field.oninput = () => {
      if(this.bar.children.length == 4) {
        this.bar.removeChild(this.bar.lastChild);
      }
      
    };
    this.bar.appendChild(this.input_field);

    this.delete_icon = document.createElement('img');
    this.delete_icon.src = Flask.url_for("static", {"filename" :'./img/times-solid.svg'});
    this.delete_icon.style = "float: right;margin-right : 0.5%;";
    this.delete_icon.onclick = this.clear.bind(this);
    this.bar.appendChild(this.delete_icon);

    this.alarm = document.createElement('div');
    this.alarm.id = "alert_box";
    
    this.alarm.innerHTML = '<div class="exclamation"><p>!</p></div> <div class="text">Please fill out the form</div>';


    this.render();
  }

  render() {
    this.ele.innerHTML = '';

    this.title.style = `margin-top: ${this.ele.offsetHeight * 0.07}px; font-size: ${Math.round(this.ele.offsetWidth * 0.025)}px; margin-bottom: ${this.ele.offsetHeight * 0.02}px;`
    this.ele.appendChild(this.title);


    this.bar.style = `height: ${this.ele.offsetHeight * 0.15}px; margin-top: ${this.ele.offsetHeight * 0.05}px;`
    this.ele.appendChild(this.bar);
  }

  clear() {
    this.input_field.value = "";
  }

  search() {
    if(this.input_field.value.length == 0) {
      let rect = this.bar.getBoundingClientRect();
      this.bar.appendChild(this.alarm);
    }else{
      this.main.do_query(this.input_field.value.toUpperCase());
    }
  }

}