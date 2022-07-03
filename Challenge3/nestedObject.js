let obj1 = {"mahesh":{"keerthi":{"parnika":{"jeevika":"home"}}}};
let keys = 'mahesh/keerthi/parnika/jeevika';

const nestedValue = (obj,keys) => {
    let arr = keys.split('/');
    let value = obj[arr[0]];
    for(let i = 1 ; i < arr.length ; i++){
        value = value[arr[i]];
    }
    return value;
}

console.log('value = ',nestedValue(obj1,keys));
//nestedValue(obj1,keys);