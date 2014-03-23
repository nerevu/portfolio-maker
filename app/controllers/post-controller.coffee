Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
ArchivesView = require 'views/archives-view'
Posts = require 'models/posts'
config = require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class PostController extends Controller
  collection = new Posts()
  collection.set mediator.postData
  collection: collection
  type: 'blog'

  initialize: =>
    # @collection.comparator = (model) -> model.get 'date'
    utils.log 'initialize post-controller'
    @collection.comparator = (model) -> - model.get 'date'
    @collection.sort()
    @recent_posts = @collection.getRecent @type

  show: (params) =>
    slug = params.slug
    utils.log "show #{slug} post-controller"
    @model = @collection.findWhere slug: slug
    title = @model.get 'title'
    active = 'Blog'
    @adjustTitle title
    @view = new ItemView
      model: @model
      active: active
      title: title
      recent_posts: @recent_posts

  index: (params) =>
    utils.log "index post-controller"
    active = 'Blog'
    title = 'My Blog'
    @adjustTitle title

    @view = new IndexView
      collection: @collection
      active: active
      title: title
      recent_posts: @recent_posts
      type: @type

  archives: (params) =>
    utils.log "archives post-controller"
    active = 'Archives'
    title = 'Blog Archives'
    @adjustTitle title
    years = @collection.pluck 'year'
    year_months = @collection.pluck 'year_month'

    setShowYear = (year) ->
      model = @collection.findWhere year: year
      count = (y for y in years when y is year).length
      model.set show_year: true
      model.set year_rowspan: count

    setShowMonth = (year_month) ->
      model = @collection.findWhere year_month: year_month
      count = (y for y in year_months when y is year_month).length
      model.set show_month: true
      model.set month_rowspan: count

    _.each _.uniq(years), setShowYear, @
    _.each _.uniq(year_months), setShowMonth, @

    @view = new ArchivesView
      collection: @collection
      active: active
      title: title
      recent_posts: @recent_posts
