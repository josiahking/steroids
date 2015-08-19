path = require 'path'

createApplicationPaths = require './create-application-paths'
detectSteroidsProject = require './detect-steroids-project'

module.exports = (baseDir) ->
  plainSteroidsProjectBaseDir = baseDir
  moduleProjectSteroidsBaseDir = path.join baseDir, 'mobile'

  if (detectSteroidsProject createApplicationPaths plainSteroidsProjectBaseDir)
    plainSteroidsProjectBaseDir
  else if (detectSteroidsProject createApplicationPaths moduleProjectSteroidsBaseDir)
    moduleProjectSteroidsBaseDir
  else
    plainSteroidsProjectBaseDir
