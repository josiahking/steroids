paths = require "../paths"
detectComposerModuleProject = require "../paths/detect-composer-module-project"
Grunt = require "../Grunt"

SteroidsProject = require "./SteroidsProject"

module.exports = class ComposerModuleProject extends SteroidsProject
  makeOnly: (options = {}) ->
    grunt = new Grunt(paths.modules.projectRootDir)
    grunt.run({ tasks: ["default"] }).then =>
      super(options)
