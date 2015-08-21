createApplicationPaths = require './paths/create-application-paths'
determineApplicationDir = require './paths/determine-application-dir'

module.exports = createApplicationPaths(
  determineApplicationDir(process.cwd())
  global.argv ? {}
)
