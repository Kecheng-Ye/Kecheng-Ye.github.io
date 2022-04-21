function createGraph(categories, strongBuy, buy, hold, sell, strongSell) {
  Highcharts.chart("container", {
    chart: {
      type: "column",
    },
    title: {
      text: "Recommendation Trends",
    },
    yAxis: {
      min: 0,
      title: {
        text: "#Analysis",
        align: "high",
      },
      stackLabels: {
        enabled: true,
        style: {
          fontWeight: "bold",
          color: "gray",
        },
      },
    },
    legend: {
      align: "center",
      verticalAlign: "bottom",
      layout: "horizontal",
      itemDistance: 7,
    },
    tooltip: {
      headerFormat: "<b>{point.x}</b><br/>",
      pointFormat: "{series.name}: {point.y}<br/>Total: {point.stackTotal}",
    },
    plotOptions: {
      column: {
        stacking: "normal",
        dataLabels: {
          enabled: true,
        },
      },
    },
    colors: ["#176f37", "#1cb954", "#b88b1d", "#f45b5a", "#813131"],

    // responsive: {
    //   rules: [
    //     {
    //       condition: {
    //         maxWidth: 500,
    //       },
    //       chartOptions: {
    //         chart: {
    //           marginBottom: 120,
    //         },
    //       },
    //     },
    //   ],
    // },
    series: [
      {
        name: "Strong buy",
        data: strongBuy,
      },
      {
        name: "Buy",
        data: buy,
      },
      {
        name: "Hold",
        data: hold,
      },
      {
        name: "Sell",
        data: sell,
      },
      {
        name: "Strong Sell",
        data: strongSell,
      },
    ],

    xAxis: {
      categories: categories,
    },
  });
}

webkit.messageHandlers.bridge.onMessage = (msg) => {
  const args = JSON.parse(`${msg}`);
  createGraph(
    args["categories"],
    args["strongBuy"],
    args["buy"],
    args["hold"],
    args["sell"],
    args["strongSell"]
  );
};
