Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
ArchivesView = require 'views/archives-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PostController extends Controller
  type: 'blog'

  initialize: =>
    utils.log 'initialize post-controller'
    @posts.comparator = (model) -> - model.get 'date'
    @posts.sort()
    @recent_posts = @posts.getRecent @type
    @posts.setPagers()

  show: (params) =>
    slug = params.slug
    utils.log "show #{slug} post-controller"
    title = @posts.findWhere({slug: slug}).get 'title'
    active = 'Blog'
    @adjustTitle title
    @view = new ItemView
      model: @posts.findWhere({slug: slug})
      active: active
      title: title
      recent_posts: @recent_posts

  index: (params) =>
    utils.log "index post-controller"
    active = 'Blog'
    title = 'My Blog'
    @adjustTitle title

    @view = new IndexView
      collection: @posts
      active: active
      title: title
      recent_posts: @recent_posts
      type: @type

  archives: (params) =>
    utils.log "archives post-controller"
    active = 'Archives'
    title = 'Blog Archives'
    @adjustTitle title
    years = @posts.pluck 'year'
    year_months = @posts.pluck 'year_month'

    setShowYear = (year) ->
      model = @posts.findWhere year: year
      count = (y for y in years when y is year).length
      model.set show_year: true
      model.set year_rowspan: count

    setShowMonth = (year_month) ->
      model = @posts.findWhere year_month: year_month
      count = (y for y in year_months when y is year_month).length
      model.set show_month: true
      model.set month_rowspan: count

    _.each _.uniq(years), setShowYear, @
    _.each _.uniq(year_months), setShowMonth, @

    @view = new ArchivesView
      collection: @posts
      active: active
      title: title
      recent_posts: @recent_posts
