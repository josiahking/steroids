fs = require 'fs'

module.exports = detectSteroidsProject = (paths) ->
  fs.existsSync(paths.application.configDir) and (fs.existsSync(paths.application.appDir) or fs.existsSync(paths.application.wwwDir))
