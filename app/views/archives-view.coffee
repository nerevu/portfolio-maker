CollectionView = require 'views/base/collection-view'
template = require 'views/templates/archives'
View = require 'views/title-view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ArchivesView extends CollectionView
  itemView: View
  autoRender: true
  listSelector: '#title-list'
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) ->
    super
    utils.log 'initializing posts view'
    @recent_posts = options.recent_posts
    @title = options.title
    mediator.setActive options.active

  render: =>
    super
    utils.log 'rendering posts view'

  getTemplateData: =>
    utils.log 'getTemplateData'
    templateData = super
    templateData.sidebar = config.blog.index_sidebar
    templateData.asides = config.blog.index_asides
    templateData.recent_posts = @recent_posts
    templateData.page_title = @title
    templateData
