CollectionView = require 'views/base/collection-view'
template = require 'views/templates/index'
View = require 'views/excerpt-view'
mediator = require 'mediator'
config = require 'config'

module.exports = class IndexView extends CollectionView
  itemView: View
  autoRender: true
  listSelector: '#excerpt-list'
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) ->
    super
    console.log 'initializing posts view'
    @type = options.type
    @recent_posts = options.recent_posts
    @title = options.title
    mediator.setActive options.active

  render: =>
    super
    console.log 'rendering posts view'

  getTemplateData: =>
    console.log 'getTemplateData'
    templateData = super
    templateData.sidebar = config[@type].index_sidebar
    templateData.collapsed = config[@type].index_collapsed
    templateData.asides = config[@type].index_asides
    templateData.recent_posts = @recent_posts
    templateData.page_title = @title
    templateData
