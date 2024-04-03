

document.addEventListener('DOMContentLoaded', function(){

    let popups = [...document.querySelectorAll('.popup')];
    popups.forEach(popup => controlPopup(popup))
    
    let forms = [...document.querySelectorAll('form')];
    forms.forEach(form => controlForm(form))





    function controlForm(form){    
        form.addEventListener('submit', event => {
            // event.preventDefault() 
        }) 
        let dataFields = form.querySelector('.select_data')
        const btnAddSelect = form.querySelector('button.add_select')
        const btnDelSelect = form.querySelector('.del_select')
        
        if (btnDelSelect) {
            btnDelSelect.addEventListener('click', event => {
                const selects = dataFields.querySelectorAll('div.select_item');
                for (let i = 1; i < selects.length; i++) {
                    dataFields.removeChild(selects[i]);
                }
                dataFields.classList.remove('scrolled');
            }); 
        }
        if (btnAddSelect) {
            const itemSelect = dataFields.querySelector('div.select_item')
            btnAddSelect.addEventListener('click', function(){
                if (dataFields.getBoundingClientRect().height > 350){
                    dataFields.classList.add('scrolled');
                }
                const newSelect = itemSelect.cloneNode(true);
                if (newSelect.querySelector('input')) {
                    newSelect.querySelector('input').value = ''
                }
                dataFields.insertBefore(newSelect, itemSelect.nextSibling);
            })
        }


    }


    function controlPopup(popup){       
        popup.addEventListener('click', event => {
            const actionDiv = popup.querySelector('.popup .back');
            if(event.target.closest('.popup .open_btn')) {
                actionDiv.classList.remove('close');
                popup.querySelector('.popup .close_btn').classList.remove('close');
            }
            if(event.target.closest('.popup .close_btn')) {
                event.target.classList.add('close');
                actionDiv.classList.add('close');
            }
        })
    }
})