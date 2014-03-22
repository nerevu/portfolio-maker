Controller = require 'controllers/base/controller'
PostView = require 'views/post-view'
PostsView = require 'views/posts-view'
Posts = require 'models/posts'
config = require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class PostController extends Controller
  collection = new Posts()
  collection.set mediator.postData
  collection: collection

  initialize: =>
    # @collection.comparator = (model) -> model.get 'date'
    utils.log 'initialize post-controller'

  show: (params) =>
    slug = params.slug
    utils.log "show #{slug} post-controller"
    @model = @collection.findWhere slug: slug
    title = @model.get 'title'
    @adjustTitle "#{title}"
    @view = new PostView {@model}

  index: (params) =>
    utils.log "show post-controller"
    @adjustTitle 'Blog'
    @collection.comparator = (model) -> - model.get 'date'
    @collection.sort()
    posts = @collection.slice 0, config.recent_posts
    recent_posts = []

    while model = posts.shift()
      href = model.get 'href'
      title = model.get 'title'
      recent_posts.push({href: href, title: title})

    @view = new PostsView
      collection: @collection
      recent_posts: recent_posts
