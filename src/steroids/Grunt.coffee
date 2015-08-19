grunt = require "grunt"

class Grunt
  constructor: (@workingDirectory) ->
    throw new Error "Grunt working directory not defined" unless @workingDirectory?

  run: (options = {}) =>

    gruntOptions = {}
    gruntTasks = options.tasks || ["default"]

    withWorkingDirectoryAs @workingDirectory, ->
      new Promise (resolve) ->
        grunt.tasks gruntTasks, gruntOptions, resolve

withWorkingDirectoryAs = (workingDirectory, f) ->
  currentWorkingDirectory = process.cwd()

  process.chdir(workingDirectory)
  Promise.resolve(f()).finally ->
    process.chdir(currentWorkingDirectory)

module.exports = Grunt
