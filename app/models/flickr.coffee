Collection = require 'models/base/collection'
Model = require 'models/photo'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

module.exports = class Flickr extends Collection
  _(@prototype).extend Chaplin.SyncMachine

  base_url = "https://api.flickr.com/services/rest/"
  base_data =
    api_key: config.flickr.api_token
    format: 'json'
    nojsoncallback: 1

  url_data =
    method: 'flickr.urls.lookupUser'
    url: "https://www.flickr.com/photos/#{config.flickr.user}/"

  model: Model
  url: "#{base_url}?#{$.param _(url_data).extend base_data}"

  local: =>
    if devconfig.testing
      false
    else
      localStorage.getItem "#{@storeName}:synced"

  sync: (method, collection, options) =>
    utils.log "#{@storeName} collection's sync method is #{method}"
    utils.log "read #{@storeName} collection from server: #{not @local()}"
    Backbone.sync(method, collection, options)

  initialize: =>
    super
    utils.log "initializing #{@type} collection"
    @syncStateChange => console.debug "#{@type} state changed"

  getCollection: (response) =>
    utils.log "get #{@type}'s flickr collection"
    data =
      method: 'flickr.collections.getTree'
      collection_id: config[@type].collection_id
      user_id: response.user.id

    $.get base_url, _(data).extend base_data

  getSets: (response) ->
    extras = "license, date_upload, date_taken, original_format, last_update,"
    extras += "geo, tags, o_dims, views, media, url_sq, url_t, url_s, url_m"
    deferreds = []

    for id in (s.id for s in response.collections.collection[0].set)
      data =
        method: 'flickr.photosets.getPhotos'
        extras: extras
        photoset_id: id

      deferreds.push $.get base_url, _(data).extend base_data

    deferreds

  applySets: (deferreds) -> $.when.apply($, deferreds)

  getData: (results...) =>
    utils.log "get #{@type} data"
    _.flatten (r[0].photoset.photo for r in results)

  parseBeforeLocalSave: (resp) =>
    return if @disposed
    utils.log "#{@type} parse"
    @getCollection(resp).then(@getSets).then(@applySets).then(@getData)

  wrapError: (options) =>
    error = options.error
    options.error = (resp) =>
      error @, resp, options if error
      @unSync()

  setData: (data, options, success=null) =>
    utils.log "setting #{@type} data"
    method = if options.reset then 'reset' else 'set'
    @[method] data, options
    utils.log @
    success @, data, options if success
    @finishSync()

  _fetch: (options) =>
    utils.log "_fetch #{@type} collection"
    @beginSync()

    options = if options then _.clone(options) else {}
    success = options.success

    if devconfig.testing
      result = require 'flickr_data'
      data = @getData [result]
      @setData data, options, success
    else
      options.success = (resp) =>
        utils.log "#{@type} success"

        if resp?.done
          collection = @

          do (collection, options, success) ->
            resp.done (data) ->
              collection.setData data, options, success
        else
          @setData resp, options, success

      @wrapError @, options
      @sync 'read', @, options

  fetch: =>
    utils.log "fetch #{@type} collection"
    $.Deferred((deferred) => @_fetch
      collection_type: @type
      success: deferred.resolve
      error: deferred.reject).promise()
