Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

module.exports = class Portfolio extends Collection
  _(@prototype).extend Chaplin.SyncMachine

  token = "access_token=#{config.github.api_token}"
  type = 'portfolio'

  type: type
  model: Model
  url: "https://api.github.com/users/#{config.github.user}/repos?#{token}"
  storeName: "#{config.title}:#{type}"

  local: =>
    if devconfig.file_storage
      true
    else
      localStorage.getItem "#{@storeName}:synced"

  sync: (method, collection, options) =>
    utils.log "#{@storeName} collection's sync method is #{method}"
    utils.log "read #{@storeName} collection from server: #{not @local()}"
    Backbone.sync(method, collection, options)

  initialize: =>
    super
    utils.log "initializing #{@type} collection"
    @syncStateChange => utils.log "#{@type} state changed"

  setData: (data, options, success=null) =>
    utils.log "setting #{@type} data"
    method = if options.reset then 'reset' else 'set'
    @[method] data, options
    utils.log @
    success @, data, options if success
    @finishSync()

  _load: (options) =>
    utils.log "_fetch #{@type} collection"
    @beginSync()

    options = if options then _.clone(options) else {}
    success = options.success
    data = require "#{@type}_data"
    @setData data, options, success

  fetch: =>
    utils.log "fetch #{@type} collection"

    $.Deferred((deferred) =>
      options =
        collection_type: @type
        success: deferred.resolve
        error: deferred.reject

      if devconfig.file_storage then @_load options else super options
    ).promise()
