Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Projects extends Collection
  token = "access_token=#{config.github.api_token}"

  model: Model
  url: "https://api.github.com/users/#{config.github.user}/repos?#{token}"
  storeName: 'Projects'
  local: -> localStorage.getItem "#{config.title}:synced"

  sync: (method, collection, options) =>
    utils.log "collection's sync method is #{method}"
    utils.log "read collection from server: #{not @local()}"
    Backbone.sync(method, collection, options)

  initialize: =>
    super
    utils.log "initialize projects collection"

  cltnFetch: =>
    $.Deferred((deferred) => @fetch
      success: deferred.resolve
      error: deferred.reject).promise()
