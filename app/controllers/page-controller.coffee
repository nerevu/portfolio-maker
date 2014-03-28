Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
utils = require 'lib/utils'

module.exports = class PageController extends Controller
  initialize: =>
    utils.log 'initialize page-controller'
    @posts.comparator = (model) -> - model.get 'date'
    @projects.comparator = (model) -> - moment model.get 'created_at'
    @photos.comparator = (model) -> - moment model.get 'created'
    @posts.sort()
    @projects.sort()
    @photos.sort()

  show: (params) =>
    page = params?.page ? 'home'
    utils.log "show #{page} page-controller"
    title = @pages.findWhere({name: page}).get 'title'
    @adjustTitle title
    @view = new ItemView
      model: @pages.findWhere({name: page})
      active: title
      title: title
      recent_posts: @posts.getRecent 'blog'
      recent_projects: @projects.getRecent 'portfolio', {fork: false}
      recent_photos: @photos.getRecent 'gallery'
