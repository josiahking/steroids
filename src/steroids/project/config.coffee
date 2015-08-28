module.exports = class Config
  constructor: ->

  @create: ->
    LegacyConfig = require "./legacy-config"
    SupersonicConfig = require "./supersonic-config"
    CordovaConfig = require "./cordova-config"

    switch
      when steroidsCli.projectType is "cordova"
        new CordovaConfig
      when steroidsCli.project.isSupersonicEnabled()
        new SupersonicConfig
      else
        new LegacyConfig

  getCurrent: =>
    return @current if @current?

    @current = Config.create().getCurrent()

  eitherSupersonicOrLegacy: ->
    Either = require "data.either"

    if steroidsCli.project.isSupersonicEnabled()
      new Either.Left("supersonic")
    else
      new Either.Right("legacy")
