CollectionView = require 'views/base/collection-view'
template = require 'views/templates/posts'
View = require 'views/excerpt-view'
mediator = require 'mediator'
config = require 'config'

module.exports = class PostsView extends CollectionView
  itemView: View
  autoRender: true
  listSelector: '#excerpt-list'
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) ->
    super
    console.log 'initializing posts view'
    mediator.setActive 'Blog'

  render: =>
    super
    console.log 'rendering posts view'

  getTemplateData: =>
    templateData = super
    templateData.sidebar = config.blog_index_sidebar
    templateData.asides = config.blog_index_asides
    templateData
