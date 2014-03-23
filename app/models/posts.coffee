Collection = require 'models/base/collection'
Model = require 'models/post'
config = require 'config'

module.exports = class Posts extends Collection
  model: Model

  initialize: =>
    super
    console.log "initialize posts collection"

  fetch: =>
    console.log "fetch posts collection"
    collection = []
    files = require 'paths'

    for file in files.posts
      base = file.split('.')[0]
      model = require "posts/#{base}"
      model.name = base
      model.id = md5 JSON.stringify model
      collection.push model

    collection
