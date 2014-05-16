Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

module.exports = class Portfolio extends Collection
  token = "access_token=#{config.github.api_token}"
  type = 'portfolio'

  type: type
  model: Model
  url: "https://api.github.com/users/#{config.github.user}/repos?#{token}"
  storeName: "#{config.title}:#{type}"

  fetch: =>
    utils.log "fetch #{@type} collection"

    $.Deferred((deferred) =>
      options =
        collection_type: @type
        success: deferred.resolve
        error: deferred.reject

      if devconfig.file_storage then @loadData options else super options
    ).promise()
