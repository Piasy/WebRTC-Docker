var express = require('express')
var crypto = require('crypto')
var app = express()

var hmac = function (key, content) {
  var method = crypto.createHmac('sha1', key)
  method.setEncoding('base64')
  method.write(content)
  method.end()
  return method.read()
}

app.get('/iceconfig', function (req, resp) {
  var query = req.query
  var key = '4080218913'
  var time_to_live = 600
  var timestamp = Math.floor(Date.now() / 1000) + time_to_live
  var turn_username = timestamp + ':ninefingers'
  var password = hmac(key, turn_username)

  return resp.send({
    iceServers: [
      {
        urls: [
          'turn:ICE_SERVER_ADDR:3478?transport=udp',
          'turn:ICE_SERVER_ADDR:3478?transport=tcp',
          'turn:ICE_SERVER_ADDR:3479?transport=udp',
          'turn:ICE_SERVER_ADDR:3479?transport=tcp'
        ],
        username: turn_username,
        credential: password
      }
    ]
  })
})

app.listen('3033', function () {
  console.log('server started')
})
