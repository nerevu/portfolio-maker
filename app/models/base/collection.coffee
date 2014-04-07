Model = require './model'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  # _(@prototype).extend Chaplin.SyncMachine
  # initialize: ->
  #   super
  #   @on 'request', @beginSync
  #   @on 'sync', @finishSync
  #   @on 'error', @unsync

  # Use the project base model per default, not Chaplin.Model
  model: Model

  prefilter: (filter=false) =>
    if  _.isFunction filter
      collection = new Collection _(@models).filter filter
    else if filter? and filter
      collection = new Collection @where filter
    else
      collection = @

    collection

  getTags: (filter=false) =>
    collection = @prefilter filter
    tags = _(_.flatten(collection.pluck 'tags')).uniq()
    filterd = _.filter tags, (tag) -> tag
    filterd.sort()
    filterd

  getModels: (collection, length) =>
    models = []
    _(collection.models).some (model) ->
      data =
        href: model.get 'href'
        title: model.get 'title'
        url_s: model.get 'url_s'
        url_m: model.get 'url_m'
        url_t: model.get 'url_t'
        url_sq: model.get 'url_sq'

      models.push(data)
      models.length is length

    models

  mergeModels: (other, attrs, tag, filter=false) =>
    console.log "mergeModels"
    collection = @prefilter filter
    other = _(other.models).filter (model) -> tag in (model.get('tags') ? [])

    _(collection.models).each (model) ->
      name = model.get('name').replace '-', ''
      filtered = _(other).filter (model) -> name in (model.get('tags') ? [])
      if filtered.length > 0
        _(attrs).each (attr) -> model.set attr, _.first(filtered)?.get attr
      else
        # utils.log "#{name} has no matching screenshots... setting default img"
        _(attrs).each (attr) ->
          model.set attr, "/images/placeholder_#{attr}-or8.png"

    collection

  paginator: (page=1, filter=false) =>
    console.log "paginator"
    collection = @prefilter filter
    per_page = config[@type]?.items_per_index ? 10
    pages = collection.length / per_page | 0
    pages = if collection.length % per_page then pages + 1 else pages
    collection = collection.rest per_page * (page - 1)
    collection = new Collection _(collection).first per_page
    first_page = page is 1
    last_page = page is pages
    only_page = pages is 1

    return {
      collection: collection
      first_page: first_page
      last_page: last_page
      only_page: only_page
      pages: pages}

  setPagers: (filter=false) =>
    console.log "setPagers"
    collection = @prefilter filter
    len = collection.length + 1
    num = len

    while num -= 1
      real = num - 1
      cur = collection.at(real)
      if real is len - 2
        cur.set last: true
        cur.set prev_href: collection.at(real - 1).get 'href'
      else if real is 0
        cur.set first: true
        cur.set next_href: collection.at(real + 1).get 'href'
      else
        cur.set prev_href: collection.at(real - 1).get 'href'
        cur.set next_href: collection.at(real + 1).get 'href'

  getRecent: =>
    console.log "get recent #{@type}"
    comparator = config[@type]?.recent_comparator

    if comparator
      filter = config[@type]?.filterer
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()
      @getModels collection, config[@type].recent_count
    else
      []

  getPopular: =>
    console.log "get popular #{@type}"
    comparator = config[@type]?.popular_comparator

    if comparator
      filter = config[@type]?.filterer
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()
      @getModels collection, config[@type].popular_count
    else
      []

  getRandom: =>
    console.log "get random #{@type}"
    length = config[@type]?.random_count

    if length
      filter = config[@type]?.filterer
      collection = if filter then @where(filter) else @models
      collection = new Collection _(collection).shuffle()
      @getModels collection, length
    else
      []

