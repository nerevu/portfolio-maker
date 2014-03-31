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

  paginator: (perPage, page, filter=false) =>
    console.log "paginator"
    collection = if filter then new Collection(@where(filter)) else @
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
    collection = if filter then new Collection(@where(filter)) else @
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

      _(collection.models).some (model) ->
        href = model.get 'href'
        title = model.get 'title'
        recent.push({href: href, title: title})
        recent.length is config[type].recent_count

    recent

  getPopular: (type) =>
    console.log "get popular #{type}"
    popular = []
    comparator = config[type]?.popular_comparator

    if comparator
      filter = config[type]?.filterer
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()

      _(collection.models).some (model) ->
        href = model.get 'href'
        title = model.get 'title'
        popular.push({href: href, title: title})
        popular.length is config[type].popular_count

    popular
