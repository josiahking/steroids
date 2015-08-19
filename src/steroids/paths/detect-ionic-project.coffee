fs = require 'fs'

module.exports = detectIonicProject = (paths) ->
  fs.existsSync paths.cordovaSupport.ionicProject
