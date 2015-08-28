paths = require "../paths"
detectComposerModuleProject = require "../paths/detect-composer-module-project"
Grunt = require "../Grunt"

ProjectBase = require "./Base"

module.exports = class SteroidsProject extends ProjectBase
  makeOnly: (options = {}) ->
    super(options).then ->
      if detectComposerModuleProject paths
        grunt = new Grunt(paths.modules.projectRootDir)
        grunt.run({ tasks: ["default"] })
