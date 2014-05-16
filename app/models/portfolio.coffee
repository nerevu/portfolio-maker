Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

module.exports = class Portfolio extends Collection
  token = "access_token=#{config.github.api_token}"
  type = 'portfolio'

  type: type
  preload: true
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

  mergeModels: (other, attrs, tag, options) =>
    placeholder = options?.placeholder ? true
    n = options?.n ? 1

    utils.log "mergeModels"
    other = _(other.models).filter (model) -> tag in (model.get('tags') ? [])
    fltr = config[type]?.filterer
    filter = (model, index=false) -> model.get(fltr.key) is fltr.value
    models = @prefilter filter

    _(models).each (model) ->
      name = model.get('name').replace /-/g, ''
      filtered = _(other).filter (model) -> name in (model.get('tags') ? [])

      _(attrs).each (attr) ->
        return if model.has attr
        if filtered.length > 0
          data = (m?.get attr for m in _.first(filtered, n))
          links = if data.length > 1 then data else _.first data
          model.set attr, links
        else if placeholder
          # utils.log "#{name} has no matching screenshots... setting default"
          model.set attr, "/images/placeholder_#{attr}-or8.png"

      model.save(patch: true) if model.changedAttributes()

  mergePortfolio: (screenshots) ->
    utils.log "mergePortfolio"

    options = {placeholder: false, n: 3}
    @mergeModels screenshots, ['url_s'], 'small'
    @mergeModels screenshots, ['url_m'], 'main'
    @mergeModels screenshots, ['url_sq'], 'square'
    @mergeModels screenshots, ['url_e'], 'extra', options
