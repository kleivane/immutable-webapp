'use strict'
var AWS = require('aws-sdk');

exports.handler = function(event, context, callback) {

  const environment = process.env.TF_ENVIRONMENT;
  const bucket = process.env.TF_BUCKET;
  const url = `https://${process.env.TF_API_URL}`;
  const sha = event.sha;
  const date = new Date().toISOString();

  const index = `<!doctype html>
  <html>
    <head>
      <meta charset="utf-8">
      <meta http-equiv="x-ua-compatible" content="ie=edge">
      <title>Immutable webapp</title>
      <meta name="description" content="Immutable webapp.">
      <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    </head>
    <body>
         <!-- environment variables -->
         <script>
         env = {
             ENV_NAME: '${environment}',
             GIT_SHA: '${sha}',
             API_URL: '${url}',
             CREATED_AT: '${date}'
         }
         </script>

         <!-- application binding -->
         <app-root></app-root>
         <!-- fully-qualified static assets -->
         <script src="${url}/assets/${sha}/main.js" type="text/javascript"></script>


     </body>
  </html>`

  var s3 = new AWS.S3();
      var params = {
          Bucket : bucket,
          Key : 'index.html',
          Body : index,
          CacheControl: 'no-store',
          ContentType: "text/html",
          ACL: "public-read"
      }

  return s3.putObject(params).promise();
}
