
SteroidsProject = require "./SteroidsProject"
CordovaProject = require "./CordovaProject"
ComposerModuleProject = require "./ComposerModuleProject"

module.exports = class ProjectFactory
  @create: ->
    switch steroidsCli.projectType
      when "cordova"
        new CordovaProject()
      when "module"
        new ComposerModuleProject()
      else
        new SteroidsProject()
