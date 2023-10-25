(async () => {
  const canvas = document.getElementById("post-count-chart");
  if (canvas == null) {
    return;
  }

  const { userId } = canvas.dataset;

  const { default: Chart } = await import("chart.js/auto");
  const { fetchJSON, isUndefined } = await import("./util.js");

  const fetchURL = `/users/${userId}/books/posted_counts`;
  const posted_counts = await fetchJSON(fetchURL);

  if (isUndefined(posted_counts) || isUndefined(posted_counts.data) || isUndefined(posted_counts.labels)) {
    throw new Error(`Failed to fetch data from ${fetchURL}.`);
  }

  const chartConfig = {
    type: "line",
    data: {
      labels: posted_counts.labels,
      datasets: [
        {
          label: "Count of books posted",
          data: posted_counts.data,
          borderColor: "rgba(0 0 255 / 1)",
          backgroundColor: "transparent",
          tension: 0.4,
        },
      ],
    },
    options: {
      title: {
        display: true,
        text: "Comparison of weekly postings",
      },
      responsive: true,
      scales: {
        y: {
          suggestedMin: 0,
          suggestedMax: 10,
        },
        x: {
          stacked: true,
        },
      },
    },
  };

  const myLineChart = new Chart(canvas, chartConfig);
})();
