fs = require 'fs'

module.exports = (paths) ->
  (endsWith paths.applicationDir, "mobile") and
    (fs.existsSync paths.modules.webHarnessDir)

endsWith = (string, substring) ->
  !!string.match new RegExp "#{substring}$"
