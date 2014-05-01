Collection = require 'models/base/collection'
Model = require 'models/page'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Pages extends Collection
  type: 'pages'
  model: Model

  initialize: =>
    super
    utils.log "initializing #{@type} collection"

  fetch: =>
    utils.log "fetch #{@type} collection"
    data = []
    files = require 'paths'

    for file in files.pages
      base = file.split('.')[0]
      model = require "pages/#{base}"
      model.name = base
      model.id = md5 JSON.stringify model
      data.push model

    @set data, type: @type
