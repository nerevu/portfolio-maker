Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ProjectController extends Controller
  collection: mediator.projects
  type: 'portfolio'

  filterer: (item, index) ->
    item.get('fork') is false

  initialize: =>
    utils.log 'initialize project-controller'
    @collection.comparator = (model) -> - moment model.get 'created_at'
    @collection.sort()
    @recent_projects = @collection.getRecent @type, {fork: false}

  show: (params) =>
    repo = params.repo
    utils.log "show #{repo} project-controller"
    @model = @collection.findWhere name: repo
    title = @model.get 'title'
    active = 'Portfolio'
    @adjustTitle title
    @view = new ItemView
      model: @model
      active: active
      title: title
      recent_projects: @recent_projects

  index: (params) =>
    utils.log "index project-controller"
    active = 'Portfolio'
    title = 'My Project Portfolio'
    @adjustTitle title

    @view = new IndexView
      collection: @collection
      active: active
      title: title
      recent_projects: @recent_projects
      filterer: @filterer
      type: 'portfolio'

