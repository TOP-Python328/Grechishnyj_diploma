document.addEventListener('DOMContentLoaded', function(){

    let popups = [...document.querySelectorAll('.popup')];
    popups.forEach(popup => controlPopup(popup))
    
    let forms = [...document.querySelectorAll('form')];
    forms.forEach(form => controlForm(form))

    let cloneds = [...document.querySelectorAll('.cloned')];
    cloneds.forEach(item => controlCloned(item))

    let selects = [...document.querySelectorAll('.select')];
    selects.forEach(select => controlSelect(select))

    function controlSelect(select){       
        const items = [...select.closest('.select').querySelectorAll('.item')]
        const current = select.closest('.select').querySelectorAll('.current')
        
        select.addEventListener('click', event => {   
            if(event.target.closest('.icon-close')) {
                items.forEach(item => item.classList.toggle('active'))
            }
            else{
                items.forEach(item => item.classList.remove('active'))
            }
            if(event.target.closest('.item')) {
                items.forEach(item => item.classList.remove('active'))
                current.dataset.value = event.target.dataset.value
                current.innerText = event.target.innerText
                console.log(current)
            }
        })
    }
    
    
    function controlCloned(item){
        item.addEventListener('click', event => {
            if(event.target.closest('.adder-clone')) {
                const itemClone = item.cloneNode(true);
                console.dir(item)
                console.dir(itemClone)
                if (item.value) itemClone.value = item.value;
                item.parentNode.insertBefore(itemClone, item.nextSibling);
                
                controlCloned(itemClone)
                selects.push(itemClone)
            };
        })
    }


    function controlForm(form){    
        const selects = form.querySelectorAll('select')    
        form.addEventListener('click', event => {
            if(event.target.closest('.additem')) console.log(selects);
        })
    }


    function controlPopup(popup){       
        popup.addEventListener('click', event => {
            const actionDiv = popup.querySelector('.popup .back');
            if(event.target.closest('.popup .open-btn')) actionDiv.classList.remove('close');
            if(event.target.closest('.popup .close-btn')) actionDiv.classList.add('close');
        })
    }

    const select1 = new Select('header', 'default value', [1,2,3,4,5,6,7,8,9]);

    console.log(select1)

})


class Select{
    type = 'customSelect';
        constructor(
            parentSelector = 'body', 
            defaultValue = 'default value',
            collection = [] 
        ){
            this.parent = document.querySelector(parentSelector);
            this.collection = collection,
            this.defaultValue = defaultValue
            this.main = document.createElement('div'); 
            this.header = document.createElement('div');
            this.current = document.createElement('span');
            this.iconClose = document.createElement('span');
            this.body = document.createElement('div');
            this.items = []
            this.toCreate();
            this.toControl();
        }

        toCreate() {
            this.parent.prepend(this.main);
            this.main.prepend(this.header);
            this.main.append(this.body);
            this.header.prepend(this.current);
            this.header.append(this.iconClose);
            this.main.classList.add('select');
            this.header.classList.add('header');
            this.body.classList.add('body');
            this.current.classList.add('current');
            this.iconClose.classList.add('icon-close');
            this.current.innerText = this.defaultValue;
            this.iconClose.innerText = `[]`;
            this.collection.forEach(item => {
                const div = document.createElement('div');
                div.innerText = item;
                div.classList.add('item');
                this.body.append(div);
                this.items.push(div);
            });
        }

        toControl(){
            
            this.main.addEventListener('click', event=>{
                if(event.target == this.iconClose) {
                    console.log('control')
                    this.items.forEach(item => item.classList.toggle('active'))
                }});
        }
}
        //     this.popup.addEventListener('keydown', event => {
        //         if(event.key === 'Escape') this.hide();
        //         this.openBtn.blur();
        //     });
        // }
        // show(){
        //     this.back.classList.remove('close');
        // }
        // hide(){
        //     this.back.classList.add('close');
        // }
    



    // function addSelect(){
    //     const popups = document.querySelectorAll('.popup');
    //     const popupName = 'popup - ' + popups.length;
    //     return new Select('body', popupName, popupName, 'Close')
    // } 