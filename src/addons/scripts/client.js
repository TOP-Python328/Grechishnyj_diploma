document.addEventListener("DOMContentLoaded", function() {
    document.querySelector(".add").addEventListener("click", function() {
        const clientTemplate = document.querySelector(".client");
        const newClient = clientTemplate.cloneNode(true);
        document.querySelector("form").insertBefore(newClient, document.querySelector(".row"));
    });
    document.querySelector(".delete").addEventListener("click", function() {
        const clients = document.querySelectorAll(".client");
        if (clients.length > 1) {
            document.querySelector("form").removeChild(clients[clients.length - 1]);
        }
    });
});

