level = require 'level'
levelws = require 'level-ws'

db = levelws level "#{__dirname}/../dbuser"

module.exports =

  checkuser: (body, callback) ->
    rs = db.createReadStream()
    result= null
    name = null
    { login, pw } =  body
    rs.on 'data', (data) ->
      [id,loginn] = data.key.split ":"
      if loginn == login
        if data.value == pw
          result = id
          name = loginn
    rs.on 'error', (err) -> callback(err)
    console.log(result)
    rs.on 'close', -> callback(null, result, name)


  save: (body, callback) ->
    { login, pw } =  body
    rs = db.createReadStream()
    highestid = 1
    rs.on 'data', (data) ->
      highestid += 1
    rs.on 'close', ->
      db.put("#{highestid}:#{login}", pw)
      callback(null, 1)
