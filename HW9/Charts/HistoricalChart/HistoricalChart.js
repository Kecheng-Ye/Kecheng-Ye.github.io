normal_grouping_units = [
  [
    "day", // unit name
    [1], // allowed multiples
  ],
];
small_grouping_units = [
  [
    "week", // unit name
    [1], // allowed multiples
  ],
];

function createGraph(ticker, ohlc, volume) {
  Highcharts.stockChart("container", {
    rangeSelector: {
      selected: 2,
    },

    title: {
      text: `${ticker} Historical`,
    },

    subtitle: {
      text: "With SMA and Volume by Price technical indicators",
    },

    yAxis: [
      {
        startOnTick: false,
        endOnTick: false,
        labels: {
          align: "right",
          x: -3,
        },
        title: {
          text: "OHLC",
        },
        height: "60%",
        lineWidth: 2,
        resize: {
          enabled: true,
        },
      },
      {
        labels: {
          align: "right",
          x: -3,
        },
        title: {
          text: "Volume",
        },
        top: "65%",
        height: "35%",
        offset: 0,
        lineWidth: 2,
      },
    ],

    tooltip: {
      split: true,
    },

    plotOptions: {
      series: {
        dataGrouping: {
          units: normal_grouping_units,
        },
      },
    },

    series: [
      {
        type: "candlestick",
        name: ticker,
        id: "stock_close",
        zIndex: 2,
        data: ohlc,
      },
      {
        type: "column",
        name: "Volume",
        id: "volume",
        data: volume,
        yAxis: 1,
      },
      {
        type: "vbp",
        linkedTo: "stock_close",
        params: {
          volumeSeriesID: "volume",
        },
        dataLabels: {
          enabled: false,
        },
        zoneLines: {
          enabled: false,
        },
      },
      {
        type: "sma",
        linkedTo: "stock_close",
        zIndex: 1,
        marker: {
          enabled: false,
        },
      },
    ],
  });
}

// to receive messages from native
webkit.messageHandlers.bridge.onMessage = (msg) => {
  const args = JSON.parse(`${msg}`);
  createGraph(args["ticker"], args["ohlc"], args["volume"]);
};
