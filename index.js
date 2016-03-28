#!/usr/bin/env node

var exec = require('child_process').exec

exec(__dirname + '/deploy.sh', function (err, out) {
  if (err) {
    throw err
  }
  console.log(out)
})
