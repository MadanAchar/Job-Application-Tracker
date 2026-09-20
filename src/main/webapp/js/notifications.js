document.addEventListener("DOMContentLoaded", function () {
    initializeNotificationBell();
    initializeToastTriggers();
});

function initializeNotificationBell() {
    const bellButton = document.querySelector("[data-dropdown-trigger='notifications']");
    const notificationCount = document.querySelector("[data-notification-count]");

    if (!bellButton || !notificationCount) {
        return;
    }

    const count = parseInt(notificationCount.getAttribute("data-notification-count"), 10);
    if (!Number.isNaN(count) && count > 0) {
        bellButton.classList.add("has-alert");
    }
}

function initializeToastTriggers() {
    document.querySelectorAll("[data-toast-message]").forEach(function (element) {
        showToast(
            element.getAttribute("data-toast-message"),
            element.getAttribute("data-toast-type") || "info"
        );
    });
}

function showToast(message, type) {
    if (!message) {
        return;
    }

    let container = document.querySelector(".toast-stack");
    if (!container) {
        container = document.createElement("div");
        container.className = "toast-stack";
        container.style.position = "fixed";
        container.style.top = "80px";
        container.style.right = "24px";
        container.style.zIndex = "80";
        container.style.display = "grid";
        container.style.gap = "12px";
        document.body.appendChild(container);
    }

    const toast = document.createElement("div");
    toast.style.minWidth = "280px";
    toast.style.padding = "14px 16px";
    toast.style.borderRadius = "12px";
    toast.style.boxShadow = "0 8px 32px rgba(0, 0, 0, 0.10)";
    toast.style.background = "var(--bg-card)";
    toast.style.border = "1px solid var(--border)";
    toast.style.color = "var(--text-primary)";
    toast.style.animation = "slideUp 250ms ease";

    if (type === "success") {
        toast.style.borderLeft = "4px solid var(--success)";
    } else if (type === "warning") {
        toast.style.borderLeft = "4px solid var(--warning)";
    } else if (type === "danger") {
        toast.style.borderLeft = "4px solid var(--danger)";
    } else {
        toast.style.borderLeft = "4px solid var(--accent)";
    }

    toast.textContent = message;
    container.appendChild(toast);

    setTimeout(function () {
        toast.remove();
        if (container && container.children.length === 0) {
            container.remove();
        }
    }, 3200);
}
