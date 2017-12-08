should = require 'should'
user = require '../src/users.coffee'

describe 'users', () ->
  it 'saves properly user', (done) ->
    body = []
    body.login = 'johndoe@gmail.com'
    body.pw = '1236'
    console.log(body)
    user.save body, (err) ->
      should.not.exist err
    done()

  it 'get', (done) ->
    # do something
    done()
