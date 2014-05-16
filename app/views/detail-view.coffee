View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ItemView extends View
  autoRender: true
  className: 'row'
  region: 'content'

  initialize: (options) =>
    super
    utils.log 'initializing detail-view'

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
      @recent_posts = mediator.blog.recent
      @popular_projects = mediator.portfolio.popular
      @popular_photos = mediator.gallery.popular

    @title = options.title
    @pager = options.pager
    mediator.setActive options.active

    if @model
      utils.log "initializing #{@model.get 'title'} detail-view"
    else
      utils.log "initializing 404 detail-view"

    @listenTo @, 'all', (event) =>
      utils.log "detail-view heard #{event}", 'debug'

    @subscribeEvent 'screenshots:synced', (screenshots) =>
      if @type isnt 'gallery'
        utils.log 'detail-view heard screenshots synced event'
        portfolio = mediator.portfolio
        portfolio.mergePortfolio screenshots
        @setTemplateData portfolio

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
    if @model
      utils.log "rendering #{@model.get 'title'} detail-view"
    else
      utils.log "rendering 404 detail-view"

    utils.log @model, 'debug'

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
      @recent = collection.recent
      @popular = collection.popular
      @related = collection.getRelated @model
    else
      sub_type = config?[collection?.type]?.sub_type
      if sub_type
        @["popular_#{sub_type}s"] = collection.popular

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
      templateData.recent_posts = @recent_posts
      templateData.popular_projects = @popular_projects
      templateData.popular_photos = @popular_photos

    templateData

