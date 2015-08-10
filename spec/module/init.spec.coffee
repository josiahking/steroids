require('chai').should()

steroidsDriver = require('./steroids-driver')

describe "module", ->

  steroids = steroidsDriver()

  describe "init", =>

    describe "with invalid options", ->
      it "fails with human readable error", ->
        steroids.module.init({
          appId: ""
          authToken: ""
        }).check ({stderr}) ->
          stderr.should.match /Please run again with/

    describe "successfully", ->
      it 'runs the command which is parsed later in these tests', ->
        steroids.module.init(
          appId: 1066
          authToken: "62e937eb1f5870ab5da0cf0dafe2d850"
          apiKey: "60fad5ac56b50ab80bfecda1e32a8e274f3030157d680a677c9fd435c3adc2f5"
          userId: 1041
        ).check ({stderr}) ->
          stderr.should.be.empty

      it "writes the configuration in file", ->
        steroids.file("config", "env.json").exists().should.be.true

      it "writes given parameters to the env file", =>
        steroids.file("config", "env.json").readJson().should.deep.equal {
          appId: 1066
          authToken: "62e937eb1f5870ab5da0cf0dafe2d850"
          apiKey: "60fad5ac56b50ab80bfecda1e32a8e274f3030157d680a677c9fd435c3adc2f5"
          userId: 1041
        }
