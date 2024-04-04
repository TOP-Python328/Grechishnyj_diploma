
const addressUrl = './addons/api/addresses.py';


async function main(){
    const response = await fetch(addressUrl)
    const dataQuery = await response.json()
    const selectRegion = document.querySelector('select[name="region"]')
    const selectDistrict = document.querySelector('select[name="district"]')
    const selectSity = document.querySelector('select[name="sity"]')
    const selects = [selectRegion, selectDistrict, selectSity]
    const regions = Object.keys(dataQuery).filter(region => region !== '').sort()
    regions.forEach(region => createOption(selectRegion, region))

    selects.forEach(select => select.addEventListener('change', event => {
        if (event.target == selectRegion) {
            selectDistrict.options.length = 1
            const districts = Object.keys(dataQuery[selectRegion.value]).filter(district => district !== '').sort()
            districts.forEach(district => createOption(selectDistrict, district))
        }
        if (event.target == selectDistrict) {
            selectSity.options.length = 1
            const sities = Object.values(dataQuery[selectRegion.value][selectDistrict.value]).filter(sity => sity !== '').sort()
            sities.forEach(sity => createOption(selectSity, sity))
        }
    }))
}
main()


function createOption(parent, value){
    const option = document.createElement('option')
    option.value = value
    option.innerText = value
    parent.append(option)
}