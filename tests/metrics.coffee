{exec} = require 'child_process'
should = require 'should'

describe "metrics", () ->

  metrics = null
  before (next) ->
    exec "rm -rf #{__dirname}/../db/*", (err, stdout) ->
      metrics = require '../src/metrics'
      next err

  it "get a true metric", (next) ->
    ## Create dummy data to then get
    metrics.save '1', [
      timestamp:(new Date '2015-11-04 14:00 UTC').getTime(), value:23
     ,
      timestamp:(new Date '2015-11-04 14:10 UTC').getTime(), value:56
    ], (err) ->
      return next err if err
      metrics.get '1', (err, metrics) ->
        return next err if err
        [m1, m2] = metrics
        m1.timestamp.should.equal (m1.timestamp)
        m1.value.should.equal (m1.value)
        m2.timestamp.should.equal (m2.timestamp)
        m2.value.should.equal (m2.value)
        next()

  
