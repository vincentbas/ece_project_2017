express = require 'express'
bodyparser = require 'body-parser'
metrics = require './metrics'
users = require './users'
session = require 'express-session'

app = express()
app.use(session({secret: 'ssshhhhh'}));


isAuthenticated = (req, res, next) ->
    if req.session.authenticated
      next()
    else
      res.redirect '/auth'

app.set 'port', '8888'
app.set 'views', "#{__dirname}/../views"
app.set 'view engine', 'pug'

app.use bodyparser.json()
app.use bodyparser.urlencoded()

app.use '/', express.static "#{__dirname}/../public"

app.get '/', isAuthenticated,  (req, res) ->
  res.render 'index',
    name: req.session.username

app.get '/auth', (req, res) ->
  res.render 'auth'

app.get '/metrics.json', (req, res) ->
  metrics.get req.session.userid, (err, data) ->
    throw next err if err
    res.status(200).json data

app.post '/metrics.json/:id', (req, res) ->
  metrics.save req.params.id, req.body, (err) ->
    throw next err if err
    res.status(200).send 'metrics saved'

app.get '/newmetrics', isAuthenticated,  (req, res) ->
  res.render 'add',
    uid: req.session.userid

app.post '/newmetrics/add', isAuthenticated, (req, res) ->
  metrics.add req.session.userid, req.body, (err) ->
    throw next err if err
    res.redirect('/')

app.get '/deletemetrics/:timestamp', (req, res) ->
  metrics.deletemetrics req.session.userid, req.params.timestamp, (err)->
    throw next err if err
    res.status(200).send "metrics deleted"

app.post '/signin', (req, res) ->
  users.checkuser req.body, (err, id, login)->
    throw next err if err
    if id != null
     req.session.authenticated = true
     req.session.userid = id
     req.session.username = login
    res.redirect('/')

app.post '/signup', (req, res) ->
  users.save req.body, (err) ->
    throw next err if err
    res.redirect('/')

app.get '/logout', (req, res) ->
  req.session.authenticated = false
  req.session.id = null
  res.redirect('/')


app.listen app.get('port'), () ->
  console.log "Server listening on #{app.get 'port'} !"
