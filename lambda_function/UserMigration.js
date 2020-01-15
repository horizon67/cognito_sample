'use strict';

const https = require('https');

const attributes = (response) => {
  return {
    "email": response.email,
    "email_verified": "true",
    "name": response.name
//    "custom:rails_app_id": response.id
  };
};

const checkUser = (server, data, callback) => {
  let postData = JSON.stringify( data );

  let https = require('https');
  let options = {
    hostname: server,
    port: 443,
    path: "/users/aws_auth",
    method: 'POST',
    headers: {
         'Content-Type': 'application/json',
         'Content-Length': postData.length
       }
  };

  console.log('checkUser', options, data)
  let req = https.request(options, (res) => {

    console.log("result", res)
    let data = "";
    res.on('data', (chunk) => {
      data += chunk;
    });
    res.on('end', () => {
      if ( data ){
        let response = JSON.parse( data );
        //console.log( 'response:', JSON.stringify(response, null, 2) );
        callback( null, response);
      } else {
        callback( "Authentication error");
      }
    });
  });

  req.on('error', (e) => {
    callback( e );
  });

  req.write( postData );
  req.end();
}

exports.handler = (event, context, callback) => {

  console.log('Migrating user:', event.userName);

  let rails_server_url = process.env.rails_server_url;

  checkUser( rails_server_url, {
    email: event.userName,
    password: event.request && event.request.password,
    access_token: process.env.rails_server_access_token
  }, (err, response ) => {
    if ( err ){
      return context.fail("Connection error", err);
    }
    if ( event.triggerSource == "UserMigration_Authentication" ) {
      // authenticate the user with your existing user directory service
      if ( response.success ) {
          event.response.userAttributes = attributes( response ) ;
          event.response.finalUserStatus = "CONFIRMED";
          event.response.messageAction = "SUPPRESS";
          console.log(event)
          console.log('Migrating user:', event.userName);
          callback(null, event)
      } else if ( response.user_exists ) {
          // Return error to Amazon Cognito
          callback("Bad password");
      } else {
        callback("Bad user");
      }
    } else if ( event.triggerSource == "UserMigration_ForgotPassword" ) {
      if ( response.user_exists ) {
        event.response.userAttributes = attributes( response ) ;
        event.response.messageAction = "SUPPRESS";
        console.log('Migrating user with password reset:', event.userName);
        callback(null, event);
      } else {
        callback("Bad user");
      }
    } else {
      // Return error to Amazon Cognito
      callback("Bad triggerSource " + event.triggerSource);
    }
  });
};
