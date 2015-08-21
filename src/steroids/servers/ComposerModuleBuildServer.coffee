express = require "express"

paths = require "../paths"

SteroidsBuildServer = require "./SteroidsBuildServer"

module.exports = class ComposerModuleBuildServer extends SteroidsBuildServer

  createExpressApp: ->
    # KLUDGE: Everything was served as application/json unless this came first
    app = express()
    app.use "/__module/harness", express.static paths.modules.webHarnessDir
    app.use "/module", express.static paths.modules.distDir
    app.use "/modules", express.static paths.modules.composerModulesDir
    app.use super()
    app
