import { template, content, identity, SUCCESS, FAILED } from "./content.js";
import { dateFormat } from "./utils.js";

const charts_format = "charts";

const groupingUnits = [
  [
    "day", // unit name
    [1], // allowed multiples
  ],
];

export default class charts_content extends content {
  process_data(data) {
    if (this.main.STATUS == FAILED || data.hasOwnProperty("Error")) {
      this.main.data[this.id] = {};
      this.main.STATUS = FAILED;
    } else {
      var price = [],
        volumn = [];

      for (var i = 0; i < data["t"].length; i++) {
        price.push([data["t"][i] * 1000, data["c"][i]]);
        volumn.push([data["t"][i] * 1000, data["v"][i]]);
      }

      this.main.data[this.id] = [price, volumn];
      this.main.STATUS = SUCCESS;
    }

    this.isReady = true;
    if (this.main.current_btn == this) this.main.render();
  }

  async show_content(element) {
    await this.wait_for_ready();

    var today = new Date();
    element.style = "";
    var chart = document.createElement("div");
    chart.id = "chart_container";
    element.appendChild(chart);

    // Create the chart
    Highcharts.stockChart("chart_container", {
      rangeSelector: {
        buttons: [
          {
            type: "day",
            count: 7,
            text: "7d",
          },
          {
            type: "day",
            count: 15,
            text: "15d",
          },
          {
            type: "month",
            count: 1,
            text: "1m",
          },
          {
            type: "month",
            count: 3,
            text: "3m",
          },
          {
            type: "month",
            count: 6,
            text: "6m",
          },
        ],
        selected: 0,
        inputEnabled: false,
      },

      plotOptions: {
        column: {
           pointPlacement: 'on'
        }
     },

      title: {
        text: `${this.main.query} Stock Price ${dateFormat(today, "yyyy-mm-d")}`,
      },

      subtitle: {
        useHTML: true,
        text: '<a href="https://finnhub.io/" target="_blank">Source: Finnhub</a>',
      },

      yAxis: [
        {
          title: {
            text: "Stock Price",
          },
          labels: {
            align: "left",
            x: 3,
          },
        },

        {
          title: {
            text: "Volumn",
          },
          labels: {
            align: "right",
            x: -5,
          },
          opposite: false,
        },
      ],

      series: [
        {
          name: `Stock Price`,
          data: this.main.data.charts[0],
          type: "area",
          yAxis: 0,
          threshold: null,
          tooltip: {
            valueDecimals: 2,
          },
          fillColor: {
            linearGradient: {
              x1: 0,
              y1: 0,
              x2: 0,
              y2: 1,
            },
            stops: [
              [0, Highcharts.getOptions().colors[0]],
              [
                1,
                Highcharts.color(Highcharts.getOptions().colors[0])
                  .setOpacity(0)
                  .get("rgba"),
              ],
            ],
          },
        },

        {
          type: "column",
          name: "Volume",
          data: this.main.data.charts[1],
          yAxis: 1,
          dataGrouping: {
            units: groupingUnits,
          },
          pointWidth: 5,
        },
      ],
    });
  }
}
