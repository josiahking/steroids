Bacon = require 'baconjs'

paths = require '../paths'

ChokidarFsWatcher = require "../fs/watcher"

module.exports = class Watcher
  constructor: (@options) ->
    { @watchExclude, @livereload, @userPaths } = @options

  getFsChangeStream: (path) =>

    watcher = new ChokidarFsWatcher {
      path
      ignored: @watchExclude || []
    }

    Bacon.fromBinder (sink) ->
      watcher.on ["add", "change", "unlink"], (path) ->
        steroidsCli.debug "connect", "detected change: #{path}"
        sink { path }

  getWatchers: =>
    watchers = [
      @getFsChangeStream(paths.application.appDir)
      @getFsChangeStream(paths.application.wwwDir)
      @getFsChangeStream(paths.application.configDir).map -> { shouldLivereload: no }
    ]

    if steroidsCli.projectType is "module"
      watchers = watchers.concat [
        @getFsChangeStream(paths.modules.configDir)
        @getFsChangeStream(paths.modules.srcDir)
      ]

    for userPath in @userPaths || []
      watchers.push @getFsChangeStream(userPath)

    watchers

  startWatching: ({ livereload, make, fullreload }) =>
    livereloadEnabled = @livereload

    projectChangeEvents = Bacon.mergeAll(@getWatchers())

    # Do not listen to new changes until current make is done to avoid potential infinite loops
    reloadEvents = projectChangeEvents.flatMapFirst((event) ->
      steroidsCli.log
        message: "Detected change, running make ..."
        refresh: false

      Bacon.fromPromise Promise.resolve(make()).then ->
        shouldLivereload = event.shouldLivereload ? yes
        steroidsCli.debug "connect", "livereload: #{livereloadEnabled} and can be livereloaded: #{shouldLivereload}"

        if livereloadEnabled and shouldLivereload
          Promise.resolve(livereload())
        else
          Promise.resolve(fullreload())
    )

    reloadEvents.subscribe (event) ->
      steroidsCli.debug "connect", "reload complete"
