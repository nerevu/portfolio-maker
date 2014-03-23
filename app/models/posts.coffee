Collection = require 'models/base/collection'
Model = require 'models/post'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Posts extends Collection
  model: Model

  initialize: =>
    super
    utils.log "initialize posts collection"

  fetch: =>
    utils.log "fetch posts collection"
    collection = []
    files = require 'paths'

    for file in files.posts
      base = file.split('.')[0]
      model = require "posts/#{base}"
      model.name = base
      model.id = md5 JSON.stringify model
      collection.push model

    collection
