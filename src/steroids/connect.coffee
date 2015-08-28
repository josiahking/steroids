class Connect

  @ParseError: class ParseError extends steroidsCli.SteroidsError

  constructor:(options={}) ->
    @port = options.port
    @showConnectScreen = options.connectScreen
    @watch = options.watch
    @livereload = options.livereload
    @watchExclude = options.watchExclude
    @cordova = options.cordova
    @simulate = options.simulate

    @prompt = null

  checkForUpdates: =>
    Updater = require "./Updater"
    updater = new Updater
    updater.check
      from: "connect"

  killConnectedVirtualClients: =>
    Simulator = require "./Simulator"
    simulatorForKillingIt = new Simulator

    Genymotion = require "./emulate/genymotion"
    genymotionForKillingIt = new Genymotion

    Android = require "./emulate/android"
    androidForKillingIt = new Android

    Promise.all([
      simulatorForKillingIt.killall().then ->
        steroidsCli.debug "Killed simulator"
      genymotionForKillingIt.killall().then ->
        steroidsCli.debug "Killed genymotion"
      androidForKillingIt.killall().then ->
        steroidsCli.debug "Killed android"
    ])

  run: () =>
    Promise.resolve().then =>
      @checkForUpdates()
      virtualClientsReady = @killConnectedVirtualClients()

      ProjectFactory = require "./project/ProjectFactory"
      @project = ProjectFactory.create()

      @project.push().then =>
        @startServer().then =>
          if @simulate
            virtualClientsReady.then =>
              Simulator = require "./Simulator"
              simulator = new Simulator()

              if typeof @simulate is 'string'
                simulator.run(
                  device: @simulate
                )
              else
                simulator.run()


  startServer: ()=>
    (new Promise (resolve, reject) =>
      Server = require "./Server"

      @server = Server.start
        port: @port
        callback: resolve
    ).then =>
      global.steroidsCli.server = @server

      BuildServerFactory = require "./servers/BuildServerFactory"
      @buildServer = BuildServerFactory.create
        server: @server
        path: "/"
        port: @port
        livereload: @livereload
        cordova: @cordova

      @server.mount(@buildServer)

      @startPrompt()

  startPrompt: ()=>
    Promise.resolve().then =>
      Prompt = require "./Prompt"
      @prompt = new Prompt
        context: @
        buildServer: @buildServer

      if @showConnectScreen
        QRCode = require "./QRCode"
        QRCode.showLocal
          port: @port

        steroidsCli.debug "connect", "Waiting for the client to connect, scan the QR code visible in your browser ..."

      refreshLoop = ()=>
        activeClients = 0;

        for ip, client of @buildServer.clients
          delta = Date.now() - client.lastSeen

          if (delta > 4000)
            delete @buildServer.clients[ip]
            steroidsCli.debug "connect", "Client disconnected: #{client.ipAddress} - #{client.userAgent}"
          else if client.new
            activeClients++
            client.new = false

            steroidsCli.debug "connect", "New client: #{client.ipAddress} - #{client.userAgent}"
          else
            activeClients++

      setInterval refreshLoop, 1000

      if @watch
        @startWatcher()

  getUserPaths: =>
    userPaths = if steroidsCli.options.argv.watch
      [].concat(steroidsCli.options.argv.watch)
    else
      []

  startWatcher: () =>
    Watcher = require './connect/Watcher'
    watcher = new Watcher {
      @watchExclude
      @livereload
      userPaths: @getUserPaths()
    }

    Promise.resolve watcher.startWatching {
      livereload: =>
        new Promise (resolve, reject)=>
          steroidsCli.debug "connect", "doLiveReload"

          steroidsCli.log "Notified all connected devices to refresh"

          @buildServer.triggerLiveReload()

          steroidsCli.debug "connect", "doLiveReload succ"
          resolve()

      make: =>
        steroidsCli.debug "connect", "doMake"
        @project.make().then =>
          steroidsCli.debug "connect", "doMake succ"
        .catch (error)=>
          steroidsCli.debug "connect", "doMake fail"
          if error.message.match /Parse error/ # coffee parser errors are of class Error
            console.log "Error parsing application configuration files: #{error.message}"
            throw new ParseError error.message
          else
            throw error

      fullreload: =>
        steroidsCli.debug "connect", "doFullReload"
        @project.package().then =>
          steroidsCli.debug "connect", "doFullReload succ"
          canBeLiveReload = true
          @prompt.refresh()

    }




module.exports = Connect
