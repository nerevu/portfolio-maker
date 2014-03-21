Collection = require 'models/base/collection'
Model = require 'models/page'
config = require 'config'

module.exports = class Pages extends Collection
  model: Model

  initialize: =>
    super
    console.log "initialize pages collection"

  fetch: =>
    collection = []
    files = require 'paths'

    for file in files.pages
      base = file.split('.')[0]
      model = require "pages/#{base}"
      model.name = base
      model.id = md5 JSON.stringify model
      collection.push model

    collection
