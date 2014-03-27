Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class PageController extends Controller
  posts: mediator.posts
  projects: mediator.projects
  collection: mediator.pages

  initialize: =>
    utils.log 'initialize page-controller'
    @posts.comparator = (model) -> - model.get 'date'
    @projects.comparator = (model) -> - moment model.get 'created_at'
    @posts.sort()
    @projects.sort()

  show: (params) =>
    page = params?.page ? 'home'
    utils.log "show #{page} page-controller"
    title = @collection.findWhere({name: page}).get 'title'
    @adjustTitle title
    @view = new ItemView
      model: @collection.findWhere name: page
      active: title
      title: title
      recent_posts: @posts.getRecent 'blog'
      recent_projects: @projects.getRecent 'portfolio', {fork: false}
