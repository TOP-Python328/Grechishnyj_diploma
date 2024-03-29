document.addEventListener('DOMContentLoaded', function(){


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
            this.current = document.createElement('input');
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
            this.current.addEventListener('input', event=>event.preventDefault)
            this.main.addEventListener('click', event=>{
                console.log(event.target)
                if(event.target == this.iconClose) this.items.forEach(item => item.classList.toggle('active')) 
                else this.items.forEach(item => item.classList.remove('active')) 
                
                if(event.target.closest('.item')) this.current.value = event.target.textContent
            });
        }
    }


    const select1 = new Select('header', 'default value', [1,2,3,4,5,6,7,8,9]);
    console.log(select1)
})


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