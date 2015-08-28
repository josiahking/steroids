paths = require "../paths"
detectComposerModuleProject = require "../paths/detect-composer-module-project"

SteroidsProject = require "./SteroidsProject"
CordovaProject = require "./CordovaProject"
ComposerModuleProject = require "./ComposerModuleProject"

module.exports = class ProjectFactory
  @create: ->
    switch
      when steroidsCli.projectType is "cordova"
        new CordovaProject()
      when detectComposerModuleProject paths
        new ComposerModuleProject()
      else
        new SteroidsProject()
