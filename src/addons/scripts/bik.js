
const bikUrl = '/addons/api/banks.py';


async function main(){
    const response = await fetch(bikUrl);
    const dataQuery = await response.json();
    
    const inputBik = document.querySelector('input[name="bik_number"]');
    const inputBikBankName = document.querySelector('input[name="bik_branch"]');
    const inputBikKs = document.querySelector('input[name="bik_ks"]');
    const inputBikAddress = document.querySelector('input[name="bik_address"]');
    const inputBikCity = document.querySelector('input[name="bik_city"]');
    
    inputBik.addEventListener('input', evt => {
        const filterQuery = dataQuery.filter(element => { return element.bik == evt.target.value })
        const instanceBank = filterQuery[0]
        if(instanceBank){
            inputBikBankName.value = instanceBank.name;
            inputBikKs.value = instanceBank.ks;
            inputBikCity.value = instanceBank.city;
            inputBikAddress.value = instanceBank.address;
        }
        
    });
}
main();


// address: "ул. Писарева, д. 32."
// bik: "045004162"
// city: "Новосибирск"
// dateadd: "2020-04-27"
// datechange: ""
// index: "630005"
// ks: "30101810150045004162"
// name: "Филиал АО АКБ \"НОВИКОМБАНК\" в г. Новосибирске"
// namemini: "Филиал АО АКБ \"НОВИКОМБАНК\" в г. Новосибирске"
// okato: "50"
// okpo: ""
// phone: ""
// regnum: "2546/6"
// srok: ""
