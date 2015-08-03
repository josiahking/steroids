path = require "path"
fs = require 'fs'

TestHelper = require "../test_helper"
oauthTokenPath = require "../devgyver_oauth_token_path"

module.exports = steroids = ->
  testHelper = new TestHelper
  testHelper.prepare()

  runGruntCommand = (args...) ->
    checkable testHelper.runInProject {
      cmd: "grunt"
      args
    }

  runSteroidsCommand = (args...) ->
    checkable testHelper.runInProject {
      args
    }

  checkable = (runner) ->
    check: (runnerAssertions) ->
      waitsFor ->
        runner.done

      runs ->
        runnerAssertions? runner

  pathToAppFile = (parts) ->
    path.join(testHelper.testAppPath, parts...)

  return new class SteroidsModuleCommandRunner

    file: (parts...) ->
      filepath = pathToAppFile parts

      readJson: -> JSON.parse fs.readFileSync filepath
      exists: -> fs.existsSync filepath
      clean: ->
        if fs.existsSync filepath
          fs.unlinkSync filepath

    module:
      help: ->
        runSteroidsCommand(
          "module"
        )

      install: (name) ->
        runSteroidsCommand(
          "module"
          "install"
          name
          "--moduleApiHost=https://modules-api.devgyver.com"
          "--oauthTokenPath=#{oauthTokenPath}"
        )

      init: (params) ->
        runSteroidsCommand(
          "module"
          "init"
          "--app-id=#{params.appId}" if params.appId?
          "--auth-token=#{params.authToken}" if params.authToken?
          "--api-key=#{params.apiKey}" if params.apiKey?
          "--user-id=#{params.userId}" if params.userId?
          "--envApiHost=https://env-api.devgyver.com"
          "--oauthTokenPath=#{oauthTokenPath}"
        )

      make: ->
        runGruntCommand(
          "steroids-make-module-env"
        )

      refresh: ->
        runSteroidsCommand(
          "module"
          "refresh"
          "--envApiHost=https://env-api.devgyver.com"
          "--oauthTokenPath=#{oauthTokenPath}"
        )

      deploy: ->
        runSteroidsCommand(
          "module"
          "deploy"
          "--moduleApiHost=https://modules-api.devgyver.com"
          "--oauthTokenPath=#{oauthTokenPath}"
        )

