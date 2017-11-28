level = require 'level'
levelws = require 'level-ws'

db = levelws level "#{__dirname}/../userdb"

module.exports =
  checkuser: (body, callback) ->
    console.log(body)
