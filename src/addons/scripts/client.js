document.addEventListener("DOMContentLoaded", function() {
    document.querySelector(".add").addEventListener("click", function() {
        const clientTemplate = document.querySelector(".client");
        const newClient = clientTemplate.cloneNode(true);
        document.querySelector("form").insertBefore(newClient, document.querySelector(".row"));
        controlTabs()
    });

    document.querySelector(".delete").addEventListener("click", function() {
        const clients = document.querySelectorAll(".client");
        if (clients.length > 1) {
            document.querySelector("form").removeChild(clients[clients.length - 1]);
        }
        controlTabs()
    });


    const controlTabs = function(){
        main();
        const switchTabs = document.querySelectorAll('.client .switch-tab');
        switchTabs.forEach(tab => {
            tab.addEventListener('click', evt => {
                const switchTab = evt.target;
                const attributeName = switchTab.getAttribute("data-fieldset");
                const client = switchTab.closest('.client');
                const fieldsets = client.querySelectorAll("fieldset")
                fieldsets.forEach(fieldset => {
                    if (fieldset.getAttribute("data-fieldset") == attributeName){
                        fieldset.classList.remove("hide")
                    }else{
                        fieldset.classList.add("hide")
                    }
                })
            })
        })
    }
    controlTabs()
});

