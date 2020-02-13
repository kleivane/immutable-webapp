'use strict'
var AWS = require('aws-sdk');

exports.handler = function(event, context, callback) {


  function putObjectToS3(bucket, key, data){
      var s3 = new AWS.S3();
          var params = {
              Bucket : bucket,
              Key : key,
              Body : data,
              CacheControl: 'no-store',
              ContentType: "text/html",
              ACL: "public-read"
          }
          s3.putObject(params, function(err, data) {
            if (err) console.log(err, err.stack); // an error occurred
            else     console.log(data);           // successful response
          });
  }

  var response = {
    statusCode: 200,
    headers: {
      'Content-Type': 'text/html; charset=utf-8'
    },
    body: '<p>Hello world! 2</p>'
  }

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
             ENV_NAME: 'test',
             GIT_SHA: 'en-sha',
             API_URL: 'https://d26qt8w4bwo4xv.cloudfront.net'
         }
         </script>

         <!-- application binding -->
         <app-root></app-root>
         <h3>Deployed at TIMESTAMP_PLACEHOLDER</h3>
         <!-- fully-qualified static assets -->
         <script src="https://d26qt8w4bwo4xv.cloudfront.net/assets/GIT_SHA_PLACEHOLDER/main.js" type="text/javascript"></script>


     </body>
  </html>`

  putObjectToS3('tf-immutable-webapp-test', 'lambda.html', index);
  callback(null, response)
}
