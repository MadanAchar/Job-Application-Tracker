document.addEventListener("DOMContentLoaded", function () {
    if (typeof Chart === "undefined") {
        return;
    }

    Chart.defaults.animation.duration = 800;
    Chart.defaults.animation.easing = "easeInOutQuart";
    Chart.defaults.plugins.tooltip.backgroundColor = "#1A1A1A";
    Chart.defaults.plugins.tooltip.padding = 10;
    Chart.defaults.plugins.tooltip.cornerRadius = 8;
    Chart.defaults.font.family = "Inter, sans-serif";
    Chart.defaults.color = "#6B7280";
    Chart.defaults.borderColor = "#E5E7EB";

    document.querySelectorAll("[data-chart]").forEach(function (canvas) {
        initializeChart(canvas);
    });
});

function initializeChart(canvas) {
    const chartType = canvas.getAttribute("data-chart");
    const labels = parseJsonAttribute(canvas, "data-labels");
    const values = parseJsonAttribute(canvas, "data-values");
    const title = canvas.getAttribute("data-title") || "";

    if (!Array.isArray(labels) || !Array.isArray(values)) {
        return;
    }

    const configuration = buildChartConfiguration(chartType, labels, values, title);
    if (!configuration) {
        return;
    }

    new Chart(canvas, configuration);
}

function buildChartConfiguration(chartType, labels, values, title) {
    const palette = [
        "#2563EB",
        "#1D4ED8",
        "#60A5FA",
        "#93C5FD",
        "#10B981",
        "#F59E0B",
        "#EF4444",
        "#4F46E5"
    ];

    if (chartType === "line") {
        return {
            type: "line",
            data: {
                labels: labels,
                datasets: [{
                    label: title,
                    data: values,
                    borderColor: "#2563EB",
                    backgroundColor: "rgba(37, 99, 235, 0.12)",
                    fill: true,
                    tension: 0.35,
                    pointRadius: 4,
                    pointHoverRadius: 5
                }]
            },
            options: defaultOptions(title)
        };
    }

    if (chartType === "bar") {
        return {
            type: "bar",
            data: {
                labels: labels,
                datasets: [{
                    label: title,
                    data: values,
                    backgroundColor: labels.map(function (_, index) {
                        return palette[index % palette.length];
                    }),
                    borderRadius: 10,
                    borderSkipped: false
                }]
            },
            options: defaultOptions(title)
        };
    }

    if (chartType === "horizontalBar") {
        return {
            type: "bar",
            data: {
                labels: labels,
                datasets: [{
                    label: title,
                    data: values,
                    backgroundColor: labels.map(function (_, index) {
                        return palette[index % palette.length];
                    }),
                    borderRadius: 10,
                    borderSkipped: false
                }]
            },
            options: {
                ...defaultOptions(title),
                indexAxis: "y"
            }
        };
    }

    if (chartType === "doughnut") {
        return {
            type: "doughnut",
            data: {
                labels: labels,
                datasets: [{
                    data: values,
                    backgroundColor: labels.map(function (_, index) {
                        return palette[index % palette.length];
                    }),
                    borderWidth: 0,
                    hoverOffset: 8
                }]
            },
            options: {
                ...defaultOptions(title),
                cutout: "68%"
            }
        };
    }

    return null;
}

function defaultOptions(title) {
    return {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: {
                display: true,
                position: "bottom",
                labels: {
                    boxWidth: 12,
                    boxHeight: 12,
                    usePointStyle: true,
                    pointStyle: "circle"
                }
            },
            title: {
                display: false,
                text: title
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                grid: {
                    color: "#F3F4F6"
                }
            },
            x: {
                grid: {
                    display: false
                }
            }
        }
    };
}

function parseJsonAttribute(element, attributeName) {
    const rawValue = element.getAttribute(attributeName);
    if (!rawValue) {
        return [];
    }

    try {
        return JSON.parse(rawValue);
    } catch (error) {
        return [];
    }
}
