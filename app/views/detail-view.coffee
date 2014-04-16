View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ItemView extends View
  autoRender: true
  className: 'row'
  region: 'content'

  listen:
    # 'all': (event) => utils.log "detail-view heard #{event}"
    'addedToParent': => utils.log "heard addedToParent"

  initialize: (options) =>
    super
    if @model
      @template = require "views/templates/#{@model.get 'template'}"
    else
      @template = require "views/templates/404"

    @id = options.id
    @type = options.type
    @sub_type = options.sub_type

    if @sub_type
      @recent = options.recent
      @popular = options.popular
      @related = options.related
    else
      @blog = mediator.blog
      @portfolio = mediator.portfolio
      @gallery = mediator.gallery

    @title = options.title
    @pager = options.pager
    mediator.setActive options.active

    if @model
      utils.log "initializing #{@model.get 'title'} detail-view"
    else
      utils.log "initializing 404 detail-view"

    @subscribeEvent 'screenshots:synced', (screenshots) =>
      if @type isnt 'gallery'
        utils.log 'detail-view heard screenshots synced event'
        @setTemplateData utils.mergePortfolio mediator.portfolio, screenshots

    @subscribeEvent 'gallery:synced', (gallery) =>
      if @type isnt 'portfolio'
        utils.log 'detail-view heard gallery synced event'
        @setTemplateData gallery

    @subscribeEvent 'portfolio:synced', (portfolio) =>
      if @type isnt 'gallery'
        utils.log 'detail-view heard portfolio synced event'
        @setTemplateData portfolio

  render: =>
    super
    utils.log "rendering detail-view"
    console.log @model

  setTemplateData: (collection) =>
    utils.log 'set detail-view template data'

    if not @model
      identifier = config[collection.type]?.identifier
      find_where = {}
      find_where[identifier] = @id
      @model = collection.findWhere find_where

    if @model
      @template = require "views/templates/#{@model.get 'template'}"
    else
      @template = require "views/templates/404"

    if @sub_type
      @recent = collection.getRecent()
      @popular = collection.getPopular()
      @related = collection.getRelated @model
    else
      @[collection.type] = collection

    @getTemplateData()
    @render()

  getTemplateData: =>
    utils.log 'get detail-view template data'
    templateData = super
    templateData.page_title = @title
    templateData.pager = @pager
    templateData.partial = @model.get 'partial' if @model

    if @sub_type
      templateData["recent_#{@sub_type}s"] = @recent
      templateData["popular_#{@sub_type}s"] = @popular
      templateData["related_#{@sub_type}s"] = @related
    else
      templateData.recent_posts = @blog.getRecent()
      templateData.recent_projects = @portfolio.getRecent()
      templateData.recent_photos = @gallery.getRecent()
      templateData.popular_projects = @portfolio.getPopular()
      templateData.popular_photos = @gallery.getPopular()

    templateData

