document.addEventListener("DOMContentLoaded", function () {
    applyPageLoadAnimation();
    initializeButtonRipples();
    initializeStatCardCountUp();
    initializeSkeletonLoaders();
});

function applyPageLoadAnimation() {
    const mainContent = document.querySelector(".content-inner");
    if (mainContent) {
        mainContent.classList.add("fade-in");
    }
}

function initializeButtonRipples() {
    document.querySelectorAll(".button, .icon-button, .action-button").forEach(function (button) {
        button.addEventListener("click", function (event) {
            const ripple = document.createElement("span");
            const rect = button.getBoundingClientRect();
            const size = Math.max(rect.width, rect.height);
            const x = event.clientX - rect.left - size / 2;
            const y = event.clientY - rect.top - size / 2;

            ripple.className = "ripple";
            ripple.style.width = size + "px";
            ripple.style.height = size + "px";
            ripple.style.left = x + "px";
            ripple.style.top = y + "px";

            button.appendChild(ripple);

            setTimeout(function () {
                ripple.remove();
            }, 400);
        });
    });
}

function initializeStatCardCountUp() {
    document.querySelectorAll("[data-count-up]").forEach(function (element) {
        const target = parseInt(element.getAttribute("data-count-up"), 10);
        if (Number.isNaN(target)) {
            return;
        }

        const duration = 600;
        const startTime = performance.now();

        function updateCount(currentTime) {
            const progress = Math.min((currentTime - startTime) / duration, 1);
            const value = Math.floor(progress * target);
            element.textContent = value;

            if (progress < 1) {
                requestAnimationFrame(updateCount);
            } else {
                element.textContent = target;
            }
        }

        requestAnimationFrame(updateCount);
    });
}

function initializeSkeletonLoaders() {
    const tableBodies = document.querySelectorAll("[data-skeleton-table]");

    tableBodies.forEach(function (tableBody) {
        const skeletonRows = tableBody.querySelectorAll(".skeleton-row");
        if (skeletonRows.length === 0) {
            return;
        }

        skeletonRows.forEach(function (row) {
            row.classList.remove("hidden");
        });

        window.addEventListener("load", function () {
            skeletonRows.forEach(function (row) {
                row.remove();
            });
        }, { once: true });
    });
}
