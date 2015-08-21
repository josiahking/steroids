paths = require "../paths"
detectComposerModuleProject = require "../paths/detect-composer-module-project"

CordovaBuildServer = require "./CordovaBuildServer"
SteroidsBuildServer = require "./SteroidsBuildServer"
ComposerModuleBuildServer = require './ComposerModuleBuildServer'

module.exports = class BuildServerFactory

  @create: (options)->
    switch
      when steroidsCli.projectType is "cordova"
        new CordovaBuildServer(options)
      when detectComposerModuleProject paths
        new ComposerModuleBuildServer(options)
      else
        new SteroidsBuildServer(options)
