fs = require 'fs'

# If an app isn't Supersonic-enabled, it's a Steroids 1.x legacy app
module.exports = detectSupersonicProject = (paths) ->
  fs.existsSync(paths.application.configs.app)
