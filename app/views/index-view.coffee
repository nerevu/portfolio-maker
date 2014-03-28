CollectionView = require 'views/base/collection-view'
template = require 'views/templates/index'
View = require 'views/excerpt-view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class IndexView extends CollectionView
  itemView: View
  autoRender: true
  listSelector: '#excerpt-list'
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) ->
    super
    utils.log 'initializing index view'
    @type = options.type
    @recent_projects = options.recent_projects
    @recent_posts = options.recent_posts
    @title = options.title
    @className = options.class ? 'row'
    mediator.setActive options.active

  initItemView: (model) ->
    new @itemView
      model: model
      className: @className

  render: =>
    super
    utils.log 'rendering index view'

  getTemplateData: =>
    utils.log 'getTemplateData'
    templateData = super
    templateData.sidebar = config[@type].index_sidebar
    templateData.collapsed = config[@type].index_collapsed
    templateData.asides = config[@type].index_asides
    templateData.recent_posts = @recent_posts
    templateData.recent_projects = @recent_projects
    templateData.page_title = @title
    templateData
