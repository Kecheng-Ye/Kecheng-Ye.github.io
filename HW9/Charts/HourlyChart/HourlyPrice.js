function createGraph(ticker, hourly_price, color) {
  //Create the chart
  Highcharts.stockChart("container", {
    rangeSelector: {
      enabled: false,
      inputEnabled: false,
    },

    navigator: {
      enabled: false,
    },

    title: {
      text: `${ticker} Hourly Price Variation`,
    },

    series: [
      {
        name: "Hourly Price",
        data: hourly_price,
        type: "line",
        color: color,
        tooltip: {
          valueDecimals: 2,
        },
      },
    ],
  });
}
// to receive messages from native
webkit.messageHandlers.bridge.onMessage = (msg) => {
  const args = JSON.parse(`${msg}`);
  createGraph(args["ticker"], args["hourly_price"], args["color"]);
};
