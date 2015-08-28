
detectSteroidsProject = require './paths/detect-steroids-project'
detectIonicProject = require './paths/detect-ionic-project'
detectCordovaProject = require './paths/detect-cordova-project'
detectComposerModuleProject = require "./paths/detect-composer-module-project"
detectSupersonicProject = require "./paths/detect-supersonic-project"

Config = require "./project/config"

module.exports = class Project
  constructor: (@paths, @argv) ->

  getConfig: =>
    return @config if @config?
    @config = new Config

  getType: =>
    return @projectType if @projectType?

    @projectType = switch
      when @argv.cordova or @isIonicProject() or @isCordovaProject()
        "cordova"
      when detectComposerModuleProject @paths
        "module"
      when detectSteroidsProject @paths
        "steroids"
      else
        # Doesn't look like a valid project.
        # Are we safe to throw an exception here?

  isIonicProject: =>
    detectIonicProject @paths

  isCordovaProject: =>
    detectCordovaProject @paths

  isSupersonicEnabled: =>
    detectSupersonicProject @paths
