Collection = require 'models/base/collection'
Model = require 'models/photo'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

module.exports = class Flickr extends Collection
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

  _fetch: (options) =>
    utils.log "_fetch #{@type} collection from backbone"
    @beginSync()

    options = if options then _.clone(options) else {}
    success = options.success

    options.success = (resp) =>
      utils.log "#{@type} success"

      if resp?.done
        collection = @
        do (collection, options, success) -> resp.done (data) ->
          collection.setData data, options, success
      else
        @setData resp, options, success

    @wrapError @, options
    @sync 'read', @, options

  fetch: =>
    utils.log "fetch #{@type} collection"

    $.Deferred((deferred) =>
      options =
        collection_type: @type
        success: deferred.resolve
        error: deferred.reject

      if devconfig.file_storage then @loadData options else @_fetch options
    ).promise()
