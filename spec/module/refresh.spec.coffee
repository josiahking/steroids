require('chai').should()

steroidsDriver = require('./steroids-driver')

describe "module", ->

  steroids = steroidsDriver()

  describe "refresh", ->

    describe "without running init first", ->

      it "fails with human readable error", ->
        steroids.file("config", "env.json").clean()

        steroids.module.refresh().check ({stderr}) ->
          stderr.should.match /Please run `steroids module init` first/

    describe "when init has already been run", ->

      it 'runs the command which is parsed later in these tests', ->
        steroids.module.init(
          appId: 1066
          authToken: "62e937eb1f5870ab5da0cf0dafe2d850"
          apiKey: "60fad5ac56b50ab80bfecda1e32a8e274f3030157d680a677c9fd435c3adc2f5"
          userId: 1041
        ).check ({stderr}) ->
          stderr.should.be.empty

      it "writes the module configuration in file", ->
        steroids.file("config", "appgyver.json").exists().should.be.true

      it "writes the environment namespace to the module config file", ->
        steroids.file("config", "appgyver.json")
          .readJson()
          .should.have.property('environment').be.defined

      it 'writes the module config when running module refresh', ->
        moduleConfig = steroids.file("config", "appgyver.json")
        moduleConfig.clean()

        steroids.module.refresh().check ->
          moduleConfig.exists().should.be.true
