document.addEventListener("DOMContentLoaded", function() {

    const controlTabs = function(){

        const switchTabs = document.querySelectorAll('.switch-tab');
        switchTabs.forEach(tab => {
            tab.addEventListener('click', evt => {
                const switchTab = evt.target;
                const attributeName = switchTab.getAttribute("data-fieldset");
                const switchBox = switchTab.closest('.switch-box');
                const fieldsets = switchBox.querySelectorAll("fieldset")
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

