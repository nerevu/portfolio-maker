Collection = require 'models/base/collection'
Model = require 'models/photo'
config = require 'config'
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
  remote: true

  initialize: =>
    super
    utils.log "initialize #{@type} collection"
    @syncStateChange => console.debug "#{@type} state changed"

  getCollection: (response) =>
    utils.log "get #{@type}'s flickr collection"
    data =
      method: 'flickr.collections.getTree'
      collection_id: config[@type].collection_id
      user_id: response.user.id

    $.get base_url, _(data).extend base_data

  getSets: (response) ->
    extras = "license, date_upload, date_taken, owner_name, icon_server,"
    extras += "original_format, last_update, geo, tags, machine_tags,"
    extras += "o_dims, views, media, path_alias, url_sq, url_t, url_s,"
    extras += "url_m, url_o"
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

  parse: (resp) =>
    return if @disposed
    console.log "#{@type} parse"
    @getCollection(resp).then(@getSets).then(@applySets).then(@getData)

  wrapError: (collection, options) ->
    error = options.error
    options.error = (resp) ->
      error collection, resp, options if error
      collection.unSync()

  _fetch: (options) =>
    utils.log "_fetch #{@type} collection"
    @beginSync()
    options = if options then _.clone(options) else {}
    success = options.success

    options.success = (resp) =>
      console.log "#{@type} success"
      method = if options.reset then 'reset' else 'set'
      setData = (data, collection, method) =>
        utils.log "setting #{@type} data"
        collection[method] data, options
        console.log collection
        success collection, data, options if success
        collection.finishSync()

      collection = @
      do (collection, method) -> collection.parse(resp).done (data) ->
        setData data, collection, method

    @wrapError @, options
    @sync 'read', @, options

  fetch: =>
    utils.log "fetch #{@type} collection"
    $.Deferred((deferred) => @_fetch
      collection_type: @type
      success: deferred.resolve
      error: deferred.reject).promise()
