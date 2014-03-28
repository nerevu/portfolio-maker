Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Projects extends Collection
  token = "access_token=#{config.github.api_token}"

  model: Model
  url: "https://api.github.com/users/#{config.github.user}/repos?#{token}"
  storeName: 'Projects'
  local: -> localStorage.getItem "#{config.title}:#{@storeName}:synced"

  sync: (method, collection, options) =>
    utils.log "#{@storeName} collection's sync method is #{method}"
    utils.log "read #{@storeName} collection from server: #{not @local()}"
    Backbone.sync(method, collection, options)

  initialize: =>
    super
    utils.log "initialize projects collection"

  fetch: =>
    utils.log "fetch projects collection"
    $.Deferred((deferred) => super
      success: deferred.resolve
      error: deferred.reject).promise()
