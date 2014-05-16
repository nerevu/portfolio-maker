Model = require './model'
config = require 'config'
devconfig = require 'devconfig'
utils = require 'lib/utils'

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  _(@prototype).extend Chaplin.SyncMachine

  local: =>
    if devconfig.file_storage
      true
    else
      localStorage.getItem "#{@storeName}:synced"

  sync: (method, collection, options) =>
    utils.log "#{@type} collection's sync method is #{method}"
    utils.log "read #{@type} collection from server: #{not @local()}"
    Backbone.sync(method, collection, options)

  initialize: =>
    super
    utils.log "initializing #{@type} collection"
    # @syncStateChange => utils.log "#{@type} heard state changed"
    @listenTo @, 'all', (event) => utils.log "#{@type} heard #{event}"

  # Use the project base model per default, not Chaplin.Model
  model: Model

  popular: => @getPopular()
  recent: => @getRecent()
  random: => @getRandom()

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

  getModels: (collection, length) ->
    models = []
    _(collection.models).some (model) ->
      data =
        href: model.get 'href'
        title: model.get 'title'
        url_s: model.get 'url_s'
        url_m: model.get 'url_m'
        url_e: model.get 'url_e'
        url_sq: model.get 'url_sq'

      models.push(data)
      models.length is length

    models



  paginator: (page=1, filter=false) =>
    utils.log "paginator"
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
    utils.log "setPagers"
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

  getFilter: =>
    filterer = config[@type]?.filterer
    filter = {}
    filter[filterer?.key] = filterer?.value
    return filter

  getRelated: (model) =>
    if model
      utils.log model, 'debug'
      utils.log "get related #{model.get 'sub_type'}s"
      language = model.get 'language'
      audience = model.get 'audience'
      tags = _(model.get 'tags').union language, audience
    else
      tags = false

    if tags
      filter = @getFilter()
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (other) ->
        language = other.get 'language'
        audience = other.get 'audience'
        other_tags = _(other.get 'tags').union language, audience
        common = _(tags).intersection other_tags
        - common.length

      collection.sort()
      models = @getModels collection, config[@type].related_count + 1
      _(models).filter (related) -> related.title isnt model.get 'title'
    else
      []

  getRecent: =>
    utils.log "get recent #{@type}"
    comparator = config[@type]?.recent_comparator

    if comparator
      filter = @getFilter()
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()
      @getModels collection, config[@type].recent_count
    else
      []

  getPopular: =>
    utils.log "get popular #{@type}"
    comparator = config[@type]?.popular_comparator

    if comparator
      filter = @getFilter()
      collection = if filter then new Collection(@where(filter)) else @
      collection.comparator = (model) -> - model.get comparator
      collection.sort()
      @getModels collection, config[@type].popular_count
    else
      []

  getRandom: =>
    utils.log "get random #{@type}"
    length = config[@type]?.random_count

    if length
      filter = @getFilter()
      collection = if filter then @where(filter) else @models
      collection = new Collection _(collection).shuffle()
      @getModels collection, length
    else
      []

  setData: (data, options, success=null) =>
    utils.log "setting #{@type} data"
    method = if options.reset then 'reset' else 'set'
    @[method] data, options
    utils.log @, 'debug'
    success @, data, options if success
    @finishSync()

  loadData: (options) =>
    utils.log "_fetch #{@type} collection"
    @beginSync()

    options = if options then _.clone(options) else {}
    success = options.success
    data = require "#{@type}_data"
    @setData data, options, success

  preloadImages: =>
  # http://stackoverflow.com/a/10240297/408556
    return if not @preload
    utils.log "preload #{@type} images"
    imgs = @paginator().collection.pluck 'url_s'
    preload = []
    img = new Image()
    _(imgs).each (url) ->
      img.src = url
      preload.push(img)

