window.addEventListener('DOMContentLoaded', function(){
    
    document.addEventListener('click', evt => {
        const action = evt.target.closest('.actions')
       
        if(action) {
            const actionBody = action.querySelector('.action-body') 
            actionBody.classList.toggle('hide')
        }
        else{
            const actionBody = document.querySelector('.action-body') 
            actionBody.classList.add('hide')
        }
    })
})