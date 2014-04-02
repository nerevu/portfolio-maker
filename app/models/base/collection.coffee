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
      console.log 'filter is function'
      collection = new Collection _(@models).filter filter
    else if filter
      console.log 'filter isnt function'
      collection = new Collection @where filter
    else
      console.log 'no filter'
      collection = @

    collection

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

  paginator: (perPage, page, filter=false) =>
    console.log "paginator"
    collection = @prefilter filter
    pages = collection.length / perPage | 0
    pages = if collection.length % perPage then pages + 1 else pages
    collection = collection.rest perPage * (page - 1)
    collection = new Collection _(collection).first perPage
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

  getRecent: (type) =>
    console.log "get recent #{type}"
    recent = []
    comparator = config[type]?.recent_comparator

    if comparator
      filter = config[type]?.filterer
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()
      @getModels collection, config[type].recent_count
    else
      []

  getPopular: (type) =>
    console.log "get popular #{type}"
    comparator = config[type]?.popular_comparator

    if comparator
      filter = config[type]?.filterer
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()
      @getModels collection, config[type].popular_count
    else
      []

  getRandom: (type) =>
    console.log "get random #{type}"
    length = config[type]?.random_count

    if length
      filter = config[type]?.filterer
      collection = if filter then @where(filter) else @models
      collection = new Collection _(collection).shuffle()
      @getModels collection, length
    else
      []

