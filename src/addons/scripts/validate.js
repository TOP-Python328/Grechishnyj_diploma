document.addEventListener('DOMContentLoaded', function(){
    const rules = {
        username: {
            regex: /^[A-Za-z0-9_-]{3,16}$/,
            error: "Поле 'username' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        password: {
            regex: /^[A-Za-z0-9_-]{3,16}$/,
            error: "Поле 'password1' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        password1: {
            regex: /^[A-Za-z0-9_-]{3,16}$/,
            error: "Поле 'password1' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        password2: {
            regex: /^[A-Za-z0-9_-]{3,16}$/,
            error: "Поле 'password2' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        email: {
            regex: /^[A-Za-z0-9_-]+@[A-Za-z0-9_-]+\.[A-Za-z]{2,3}$/,
            error: "Поле 'email' должно быть валидным адресом электронной почты"
        },
        room_name: {
            regex: /^[A-Za-zА-Яа-яё0-9_-]{3,16}$/,
            error: "Поле 'room_name' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        flat_name: {
            regex: /^[A-Za-zА-Яa-яё0-9 _.-]{3,16}$/,
            error: "Поле 'flat_name' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        floor_name: {
            regex: /^[A-Za-zА-Яa-яё0-9 _.-]{3,16}$/,
            error: "Поле 'floor_name' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        section_name: {
            regex: /^[A-Za-zА-Яa-яё0-9 _.-]{3,16}$/,
            error: "Поле 'section_name' должно содержать не менее 3 и не более 16 символов (A-Z, a-z, 0-9, _ и -)"
        },
        // street: {
        //     regex: /^[A-Za-z0-9_-.]{3,32}$/,
        //     error: "Поле 'secstreettion_name' должно содержать не менее 3 и не более 32 символов (A-Z, a-z, 0-9, _ и -)"
        // },
        // home: {
        //     regex: /^[A-Za-z0-9]{1,4}$/,
        //     error: "Поле 'home' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        // },
        // home: {
        //     regex: /^[1-9][0-9]*[A-Za-zА-Яа-я]$/,
        //     error: "Поле 'home' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        // },
        house_number: {
            regex: /^[1-9]\d*(?: ?(?:[A-Za-zА-Яа-я]|[\/-] ?\d+[A-Za-zА-Яа-я]?))?$/,
            error: "Поле 'house_number' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },
        square: {
            regex: /^[0-9]*(.[0-9]{1}[1-9]{1})?$/,
            error: "Поле 'square' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },
        number: {
            regex: /^[A-Za-zА-Яа-яё0-9][A-Za-zА-Яа-яё0-9\/: -_]{3,64}$/,
            error: "Поле 'number' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },
        kadastr_number: {
            regex: /^^[0-9:]{3,24}$/,
            error: "Поле 'kadastr_number' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },
        usage: {
            regex: /^[A-Za-zА-Яа-яё0-9][A-Za-zА-Яа-яё0-9 ]{3,64}$/,
            error: "Поле 'usage' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },
        owner_number: {
            regex: /^[A-Za-zА-Яа-яё0-9][A-Za-zА-Яа-яё0-9\/: -_]{3,64}$/,
            error: "Поле 'owner_number' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },
        owner_reg_number: {
            regex: /^[A-Za-zА-Яа-яё0-9][A-Za-zА-Яа-яё0-9\/: -_]{3,64}$/,
            error: "Поле 'owner_reg_number' должно содержать не менее 1 и не более 4 символов (A-Z, a-z, 0-9)"
        },

    };

    

    let forms = [...document.querySelectorAll('form')];
    forms.forEach(form => controlForm(form));

    function controlForm(form){
        form.addEventListener('submit', event => {
            event.preventDefault();
            let errors = [];

            const elements = [...form.elements];
            elements.forEach(element => {
                if (element.type == "text" || element.type == "password") {
                    const rule = rules[element.name];
                    if (rule) {
                        const reg = rule.regex;
                        const value = element.value;
                        const isDoneValid = new RegExp(reg).test(value);
                        if (!isDoneValid || !element.value) {
                            element.classList.add('not-done-valid');
                            element.classList.remove('done-valid');
                            errors.push(rule.error)
                        } else {
                            element.classList.remove('not-done-valid');
                            element.classList.add('done-valid');
                        }
                    }
                }
            });
            if (errors.length == 0) {
                form.submit();
            }
        });
    }


});


