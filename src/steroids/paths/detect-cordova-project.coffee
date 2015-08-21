fs = require 'fs'

module.exports = (paths) ->
  fs.existsSync paths.cordovaSupport.configXml
