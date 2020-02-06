const appHeading = document.createElement("h1");
const appVersion = document.createTextNode(`App version [${env.ENV_NAME}]: ${env.GIT_SHA.slice(0,7)}`)
appHeading.appendChild(appVersion);

const versionHeading = document.createElement("h2");
const timestampBuild = document.createTextNode(`Build created at ${timestamp}`)
versionHeading.appendChild(timestampBuild);

var root = document.getElementsByTagName('app-root')[0]
root.appendChild(appHeading);
root.appendChild(versionHeading);
