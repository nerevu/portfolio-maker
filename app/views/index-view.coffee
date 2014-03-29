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
    @recent_photos = options.recent_photos
    @pages = options.pages
    @first_page = options.first_page
    @last_page = options.last_page
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
    utils.log 'get index view template data'
    templateData = super
    templateData.sidebar = config[@type].index_sidebar
    templateData.collapsed = config[@type].index_collapsed
    templateData.asides = config[@type].index_asides
    templateData.recent_posts = @recent_posts
    templateData.recent_projects = @recent_projects
    templateData.recent_photos = @recent_photos
    templateData.page_title = @title
    templateData.pages = @pages
    templateData.first_page = @first_page
    templateData.last_page = @last_page
    templateData.type = @type
    templateData
