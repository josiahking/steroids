paths = require '../../paths'
http = require '../../httpRequest'
RuntimeConfig = require '../../RuntimeConfig'

writeJsonStringTo = require '../writeJsonStringTo'
readJsonConfigFrom = require '../readJsonConfigFrom'

module.exports = refreshModule = (appId = null) ->
  appId ?= readAppId()

  Promise.resolve(appId)
    .then(retrieveEnvironment)
    .then(writeJsonStringTo pickConfigurationFile())

readAppId = ->
  readJsonConfigFrom(paths.modules.configs.env).appId

retrieveEnvironment = (id) ->
  http.requestAuthenticated(
    method: "GET"
    url: RuntimeConfig.endpoints.getEnvApiUrl(id)
    json: true
  )

# KLUDGE: Packager needs to be able to run `steroids module refresh` in a regular steroids project
pickConfigurationFile = ->
  switch steroidsCli.projectType
    when "module"
      paths.modules.configs.appgyver
    else
      paths.application.configs.appgyver
