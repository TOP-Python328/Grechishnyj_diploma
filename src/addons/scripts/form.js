

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
        const btnDelSelect = form.querySelector('button.del_select')
        let countSelects = form.querySelector('span.btn_round')
        
        if (btnDelSelect) {
            btnDelSelect.addEventListener('click', event => {
                if(+countSelects.textContent > 0) countSelects.textContent = 1
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
                countSelects.textContent = +countSelects.textContent + 1
                if (dataFields.getBoundingClientRect().height > 300){
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