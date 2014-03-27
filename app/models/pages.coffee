Collection = require 'models/base/collection'
Model = require 'models/page'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Pages extends Collection
  model: Model

  initialize: =>
    super
    utils.log "initialize pages collection"

  fetch: =>
    utils.log "fetch pages collection"
    data = []
    files = require 'paths'

    for file in files.pages
      base = file.split('.')[0]
      model = require "pages/#{base}"
      model.name = base
      model.id = md5 JSON.stringify model
      data.push model

    @set data
