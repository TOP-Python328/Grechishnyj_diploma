window.addEventListener('DOMContentLoaded', function () {

    const submenus = [...document.querySelectorAll('.submenu')];
    const navTitles = [...document.querySelectorAll('.nav-title')];

    document.addEventListener('click', event => {
        const targetNavTitleSpan = event.target.closest('.nav-title span');
        const targetNavTitle = event.target.closest('.nav-title');
        
        if (targetNavTitleSpan && targetNavTitle.querySelector('.submenu')) {
            const submenu = targetNavTitle.querySelector('.submenu');
            submenu.classList.toggle('hide');
            
            navTitles.forEach(navTitle => {
                if (navTitle !== targetNavTitle && navTitle.querySelector('.submenu')) {
                    navTitle.querySelector('.submenu').classList.add('hide');
                }
            });
        } 
        else {
            submenus.forEach(menu => {
                if (!menu.classList.contains('hide')) {
                    menu.classList.add('hide');
                }
            });
        }
    });
});


