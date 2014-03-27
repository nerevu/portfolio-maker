Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ProjectController extends Controller
  type: 'portfolio'

  filterer: (item, index) ->
    item.get('fork') is false

  initialize: =>
    utils.log 'initialize project-controller'
    @projects.comparator = (model) -> - model.get 'created'
    @projects.sort()
    @recent_projects = @projects.getRecent @type, {fork: false}

  show: (params) =>
    repo = params.repo
    utils.log "show #{repo} project-controller"
    title = @projects.findWhere({name: repo}).get 'title'
    active = 'Portfolio'
    @adjustTitle title
    @view = new ItemView
      model: @projects.findWhere({name: repo})
      active: active
      title: title
      recent_projects: @recent_projects

  index: (params) =>
    utils.log "index project-controller"
    active = 'Portfolio'
    title = 'My Project Portfolio'
    @adjustTitle title

    @view = new IndexView
      collection: @projects
      active: active
      title: title
      recent_projects: @recent_projects
      filterer: @filterer
      type: 'portfolio'

