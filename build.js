const moment = require('moment');
const fs = require('fs-extra')

const timestamp = moment().format();
fs.emptyDirSync('build')
fs.appendFileSync('build/main.js', `const timestamp = "${timestamp}";`, 'utf8');
fs.appendFileSync('build/main.js', fs.readFileSync('src/main.js'));
