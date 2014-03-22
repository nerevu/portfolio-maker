Controller = require 'controllers/base/controller'
PostView = require 'views/post-view'
Posts = require 'models/posts'
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
