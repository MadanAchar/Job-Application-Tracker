document.addEventListener("DOMContentLoaded", function () {
    const body = document.body;
    const toggleButtons = document.querySelectorAll("[data-theme-toggle]");

    if (localStorage.getItem("theme") === "dark") {
        body.classList.add("dark-mode");
    }

    toggleButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            body.classList.toggle("dark-mode");
            const theme = body.classList.contains("dark-mode") ? "dark" : "light";
            localStorage.setItem("theme", theme);
        });
    });
});
