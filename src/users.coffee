level = require 'level'
levelws = require 'level-ws'

db = levelws level "#{__dirname}/../userdb"

module.exports =

  checkuser: (body, callback) ->
    rs = db.createReadStream()
    result=[]
    { login, pw } =  body
    rs.on 'data', (data) ->
      if data.key == login
        if data.value == pw
          console.log(data.key)
          console.log(data.value)
          result = data.key
    rs.on 'error', (err) -> callback(err)
    rs.on 'close', (err) -> callback(null, result)


  save: (body, callback) ->
    { login, pw } =  body
    db.put("#{login}/", pw)
    callback(null, 1)
