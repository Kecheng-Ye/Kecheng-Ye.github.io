function createGraph(categories, estimate, actual) {
  Highcharts.chart("container", {
    chart: {
      type: "spline",
    },

    title: {
      text: "Historical EPS Surprise",
    },

    yAxis: {
      title: {
        text: "Quaterly EPS",
      },
    },

    xAxis: {
      categories: categories,
      useHTML: true,
    },

    legend: {
      align: "center",
      verticalAlign: "bottom",
      x: 0,
      y: 0,
    },

    tooltip: {
      headerFormat: "{point.x}<br>",
      shared: true,
      useHTML: true,
    },

    label: {
      enabled: false,
    },

    series: [
      {
        name: "estimate",
        data: estimate,
        label: false,
      },
      {
        name: "actual",
        data: actual,
        label: false,
      },
    ],
  });
}

webkit.messageHandlers.bridge.onMessage = (msg) => {
  const args = JSON.parse(msg);
  createGraph(args["categories"], args["estimate"], args["actual"]);
};
