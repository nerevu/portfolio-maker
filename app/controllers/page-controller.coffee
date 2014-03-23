Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
Pages = require 'models/pages'
Posts = require 'models/posts'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class PageController extends Controller
  posts = new Posts()
  posts.set mediator.postData
  posts: posts
  projects: mediator.projects

  initialize: =>
    utils.log 'initialize page-controller'
    @posts.comparator = (model) -> - model.get 'date'
    @projects.comparator = (model) -> - moment model.get 'created_at'
    @posts.sort()
    @projects.sort()

  show: (params) =>
    collection = new Pages()
    collection.set mediator.pageData
    page = params?.page ? 'home'
    utils.log "show #{page} page-controller"
    @model = collection.findWhere name: page
    title = @model.get 'title'
    @adjustTitle title
    @view = new ItemView
      model: @model
      active: title
      title: title
      recent_posts: @posts.getRecent 'blog'
      recent_projects: @projects.getRecent 'portfolio', {fork: false}
