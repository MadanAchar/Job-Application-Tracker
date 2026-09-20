document.addEventListener("DOMContentLoaded", function () {
    initializeSidebar();
    initializeDropdowns();
    initializeModals();
    initializeDeleteActions();
    initializeTagInputs();
    initializePasswordStrength();
    initializeUploadZones();
});

function initializeSidebar() {
    const shell = document.querySelector(".app-shell");
    const toggleButton = document.querySelector("[data-sidebar-toggle]");
    const sidebar = document.querySelector(".sidebar");

    if (!shell || !toggleButton || !sidebar) {
        return;
    }

    toggleButton.addEventListener("click", function () {
        shell.classList.toggle("sidebar-collapsed");
        sidebar.classList.toggle("collapsed");
    });
}

function initializeDropdowns() {
    const triggers = document.querySelectorAll("[data-dropdown-trigger]");

    triggers.forEach(function (trigger) {
        trigger.addEventListener("click", function (event) {
            event.stopPropagation();
            const targetName = trigger.getAttribute("data-dropdown-trigger");
            const targetPanel = document.querySelector('[data-dropdown-panel="' + targetName + '"]');

            document.querySelectorAll(".dropdown-panel.visible").forEach(function (panel) {
                if (panel !== targetPanel) {
                    panel.classList.remove("visible");
                }
            });

            if (targetPanel) {
                targetPanel.classList.toggle("visible");
            }
        });
    });

    document.addEventListener("click", function () {
        document.querySelectorAll(".dropdown-panel.visible").forEach(function (panel) {
            panel.classList.remove("visible");
        });
    });
}

function initializeModals() {
    const openButtons = document.querySelectorAll("[data-modal-open]");
    const closeButtons = document.querySelectorAll("[data-modal-close]");

    openButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const modalName = button.getAttribute("data-modal-open");
            const modal = document.querySelector('[data-modal="' + modalName + '"]');

            if (modal) {
                modal.classList.add("visible");
            }
        });
    });

    closeButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            const modal = button.closest(".modal-backdrop");

            if (modal) {
                modal.classList.remove("visible");
            }
        });
    });

    document.querySelectorAll(".modal-backdrop").forEach(function (modal) {
        modal.addEventListener("click", function (event) {
            if (event.target === modal) {
                modal.classList.remove("visible");
            }
        });
    });
}

function initializeDeleteActions() {
    const deleteButtons = document.querySelectorAll("[data-delete-id]");
    const hiddenField = document.querySelector("[data-delete-target]");
    const labelTarget = document.querySelector("[data-delete-label]");

    deleteButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            if (hiddenField) {
                hiddenField.value = button.getAttribute("data-delete-id");
            }

            if (labelTarget) {
                labelTarget.textContent =
                    button.getAttribute("data-delete-name") || "this record";
            }
        });
    });
}

function initializeTagInputs() {
    const containers = document.querySelectorAll("[data-tag-input]");

    containers.forEach(function (container) {
        const input = container.querySelector("input");
        const hiddenFieldSelector = container.getAttribute("data-target");
        const hiddenField = hiddenFieldSelector
            ? document.querySelector(hiddenFieldSelector)
            : null;

        if (!input || !hiddenField) {
            return;
        }

        // Sync existing tags already present on page
        syncTags(container, hiddenField);

        input.addEventListener("keydown", function (event) {
            if (event.key === "Enter") {
                event.preventDefault();

                const value = input.value.trim();

                if (!value) {
                    return;
                }

                addTag(container, hiddenField, value);
                input.value = "";
            }
        });

        // Add text when user clicks outside the field
        input.addEventListener("blur", function () {
            const value = input.value.trim();

            if (value) {
                addTag(container, hiddenField, value);
                input.value = "";
            }
        });

        container.addEventListener("click", function (event) {
            const removeButton = event.target.closest("[data-remove-tag]");

            if (!removeButton) {
                return;
            }

            removeButton.parentElement.remove();
            syncTags(container, hiddenField);
        });
    });
}

function addTag(container, hiddenField, value) {
    const tag = document.createElement("span");

    tag.className = "tag-pill";
    tag.setAttribute("data-tag-value", value);
    tag.innerHTML =
        value + '<button type="button" data-remove-tag>&times;</button>';

    container.insertBefore(tag, container.querySelector("input"));

    syncTags(container, hiddenField);
}

function syncTags(container, hiddenField) {
    const tags = Array.from(
        container.querySelectorAll("[data-tag-value]")
    ).map(function (tag) {
        return tag.getAttribute("data-tag-value");
    });

    hiddenField.value = tags.join(", ");
}

function initializePasswordStrength() {
    const passwordInput = document.querySelector("[data-password-strength]");
    const strengthFill = document.querySelector("[data-password-strength-fill]");
    const strengthText = document.querySelector("[data-password-strength-text]");

    if (!passwordInput || !strengthFill || !strengthText) {
        return;
    }

    passwordInput.addEventListener("input", function () {
        const value = passwordInput.value;

        let strength = "weak";
        let label = "Weak password";

        const hasLetters = /[A-Za-z]/.test(value);
        const hasNumbers = /\d/.test(value);
        const hasSymbols = /[^A-Za-z0-9]/.test(value);

        if (value.length >= 10 && hasLetters && hasNumbers && hasSymbols) {
            strength = "strong";
            label = "Strong password";
        } else if (value.length >= 7 && hasLetters && hasNumbers) {
            strength = "medium";
            label = "Medium password";
        }

        strengthFill.className = "password-strength-fill " + strength;
        strengthText.textContent = label;
    });
}

function initializeUploadZones() {
    const zones = document.querySelectorAll("[data-upload-zone]");

    zones.forEach(function (zone) {
        const inputSelector = zone.getAttribute("data-input");
        const nameSelector = zone.getAttribute("data-file-name");

        const input = inputSelector
            ? document.querySelector(inputSelector)
            : null;

        const fileNameTarget = nameSelector
            ? document.querySelector(nameSelector)
            : null;

        if (!input) {
            return;
        }

        zone.addEventListener("click", function () {
            input.click();
        });

        zone.addEventListener("dragover", function (event) {
            event.preventDefault();
            zone.classList.add("dragover");
        });

        zone.addEventListener("dragleave", function () {
            zone.classList.remove("dragover");
        });

        zone.addEventListener("drop", function (event) {
            event.preventDefault();
            zone.classList.remove("dragover");

            if (event.dataTransfer.files.length > 0) {
                input.files = event.dataTransfer.files;
                updateFileName(input, fileNameTarget);
            }
        });

        input.addEventListener("change", function () {
            updateFileName(input, fileNameTarget);
        });
    });
}

function updateFileName(input, fileNameTarget) {
    if (!fileNameTarget || !input.files || input.files.length === 0) {
        return;
    }

    fileNameTarget.textContent = input.files[0].name;
}