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
    rs.on 'close', -> callback(null, result, name)


  save: (body, callback) ->
    { login, pw } =  body
    patt_email = /^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$/i
    res_email = patt_email.test(login);
    patt_pw = /^.{6,}$/i
    res_pw = patt_pw.test(pw);
    if res_email == true && res_pw == true
      rs = db.createReadStream()
      highestid = 1
      rs.on 'data', (data) ->
        highestid += 1
      rs.on 'close', ->
        db.put("#{highestid}:#{login}", pw)
        callback(null, 1)
