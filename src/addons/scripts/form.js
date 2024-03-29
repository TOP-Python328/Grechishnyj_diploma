

document.addEventListener('DOMContentLoaded', function(){

    let popups = [...document.querySelectorAll('.popup')];
    popups.forEach(popup => controlPopup(popup))
    
    let forms = [...document.querySelectorAll('form')];
    forms.forEach(form => controlForm(form))


    let dataFields = document.querySelector('.select-data')
    const btnAddSelect = document.querySelector('button.add-select')
    const btnDelSelect = document.querySelector('.del-select')
    const itemSelect = dataFields.querySelector('div.select-item')
    btnAddSelect.addEventListener('click', function(){
        const newSelect = itemSelect.cloneNode(true);
        newSelect.querySelector('input').value = ''
        dataFields.insertBefore(newSelect, itemSelect.nextSibling);
    })
    btnDelSelect.addEventListener('click', event => {
        const selects = dataFields.querySelectorAll('div.select-item');
        for (let i = 1; i < selects.length; i++) {
            dataFields.removeChild(selects[i]);
        }
    });


    function controlForm(form){    
        form.addEventListener('submit', event => {
            // event.preventDefault() 
        })  
    }


    function controlPopup(popup){       
        popup.addEventListener('click', event => {
            const actionDiv = popup.querySelector('.popup .back');
            if(event.target.closest('.popup .open-btn')) actionDiv.classList.remove('close');
            if(event.target.closest('.popup .close-btn')) actionDiv.classList.add('close');
        })
    }
})