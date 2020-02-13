'use strict'
var AWS = require('aws-sdk');

exports.handler = function(event, context, callback) {


  function putObjectToS3(bucket, key, data){
      var s3 = new AWS.S3();
          var params = {
              Bucket : bucket,
              Key : key,
              Body : data
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
    body: '<p>Hello world!</p>'
  }

  putObjectToS3('tf-immutable-webapp-test', 'lambda.html', '<p>Hello world!</p>');
  callback(null, response)
}
