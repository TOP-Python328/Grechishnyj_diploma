document.addEventListener('DOMContentLoaded', function(){

    function controlPopup(){ 
                  
        document.addEventListener('click', event =>{
            const popup = event.target.closest('.popup');
            if(!popup) return;
            const actionDiv = popup.querySelector('.popup .back');
            if(event.target.closest('.popup .open-btn')) actionDiv.classList.remove('close');
            if(event.target.closest('.popup .close-btn')) actionDiv.classList.add('close');
            // if(event.target.closest('.popup .back')) actionDiv.classList.add('close');
        })
    }

})