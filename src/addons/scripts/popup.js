document.addEventListener('DOMContentLoaded', function(){

    let popups = [...document.querySelectorAll('.popup')];
    popups.forEach(popup => controlPopup(popup))


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