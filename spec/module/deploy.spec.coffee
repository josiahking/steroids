require('chai').should()

steroidsDriver = require('./steroids-driver')

describe "module", ->

  steroids = steroidsDriver()

  deploymentDescriptionFile = steroids.file("config", "deployment.json")
  deploymentDescriptionFile.clean()

  getCurrentVersion = ->
    deploymentDescriptionFile.readJson().versions?[0]?.version

  getLastUploadTimestamp = ->
    deploymentDescriptionFile.readJson().versions?[0]?.module_zip_last_uploaded_at

  describe "deploy", ->

    describe "when running for the first time", ->
      it "successfully runs grunt", ->
        steroids.module.deploy().check ({stdout, stderr}) ->
          stderr.should.be.empty
          stdout.should.match /Running "[^"]+" task/

      it "creates a deployment description", ->
        deploymentDescriptionFile.exists().should.be.true

      describe "deployment description", ->
        it "should have an identifier for the module", ->
          deploymentDescriptionFile.readJson().should.have.property('id').be.defined

        it "should have a version identifier", ->
          expect(getCurrentVersion()).toBeTruthy()

        it "should have a last upload timestamp", ->
          expect(getLastUploadTimestamp()).toBeTruthy()

    describe "when already deployed once", ->
      it "updates the deployment description", ->
        deploymentDescription = deploymentDescriptionFile.readJson()

        steroids.module.deploy().check ({stdout, stderr}) ->
          stderr.should.be.empty

          deploymentDescription.should.not.deep.equal(deploymentDescriptionFile.readJson())

      describe "deployment description", ->
        it "should have an identifier for the module", ->
          expect(deploymentDescriptionFile.readJson().id).toBeTruthy()

        it "has an incremented current version and last upload timestamp", ->
          lastDeployment = {
            version: getCurrentVersion()
            timestamp: getLastUploadTimestamp()
          }

          steroids.module.deploy().check ->
            lastDeployment.should.not.deep.equal {
              version: getCurrentVersion()
              timestamp: getLastUploadTimestamp()
            }
