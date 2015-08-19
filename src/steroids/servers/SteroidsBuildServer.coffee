express = require "express"

paths = require "../paths"
detectComposerModuleProject = require "../paths/detect-composer-module-project"

BuildServerBase = require "./BuildServerBase"

module.exports = class SteroidsBuildServer extends BuildServerBase

  constructor: (options)->
    options.logDir = paths.application.logDir
    options.logFile = paths.application.logFile
    options.distDir = paths.application.distDir

    super options

  createExpressApp: ->
    if detectComposerModuleProject paths
      # KLUDGE: Everything was served as application/json unless this came first
      app = express()
      app.use "/__module/harness", express.static paths.modules.webHarnessDir
      app.use super()
      app
    else
      super()
