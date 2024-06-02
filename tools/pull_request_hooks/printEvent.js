// printEvent.js
//const { toJson } = require('your-toJson-module'); // Replace 'your-toJson-module' with the actual module name

const eventJson = process.argv[2];
const eventObject = JSON.parse(eventJson);
console.log(toJson(eventObject));
