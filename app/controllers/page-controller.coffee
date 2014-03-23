Controller = require 'controllers/base/controller'
PageView = require 'views/page-view'
Pages = require 'models/pages'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class PageController extends Controller
  initialize: =>
    utils.log 'initialize page-controller'

  show: (params) =>
    collection = new Pages()
    collection.set mediator.pageData
    page = params?.page ? 'home'
    utils.log "show #{page} page-controller"
    @model = collection.findWhere name: page
    title = @model.get 'title'
    @adjustTitle title
    @view = new PageView
      model: @model
      active: title
      title: title
