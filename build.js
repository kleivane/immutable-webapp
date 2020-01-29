const fs = require('fs-extra')

fs.emptyDirSync('build')
fs.copySync('src', 'build')
