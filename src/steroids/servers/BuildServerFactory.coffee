CordovaBuildServer = require "./CordovaBuildServer"
SteroidsBuildServer = require "./SteroidsBuildServer"
ComposerModuleBuildServer = require './ComposerModuleBuildServer'

module.exports = class BuildServerFactory

  @create: (options)->
    switch steroidsCli.projectType
      when "cordova"
        new CordovaBuildServer(options)
      when "module"
        new ComposerModuleBuildServer(options)
      else
        new SteroidsBuildServer(options)
