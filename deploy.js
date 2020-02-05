const moment = require('moment');
const fs = require('fs-extra')
const replace = require('replace-in-file');
const commandLineArgs = require('command-line-args')


const args = commandLineArgs([
  { name: 'environment', alias: 'e', type: String },
  { name: 'sha', alias: 's', type: String }
])


const timestamp = moment().format();
const replaceOptions = {
  files: 'server/index.html',
  from: [
    /ENV_NAME_PLACEHOLDER/g,
    /API_URL_PLACEHOLDER/g,
    /GIT_SHA_PLACEHOLDER/g,
    /TIMESTAMP_PLACEHOLDER/g
  ],
  to: [
    args.environment,
    'http://d2w5n29vcru7qq.cloudfront.net',
    args.sha,
    timestamp
  ],
};

try {
  const results = replace.sync(replaceOptions);
  console.log('Replacement results:', results);
}
catch (error) {
  console.error('Error occurred:', error);
}
