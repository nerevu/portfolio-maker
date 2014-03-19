CollectionView = require 'views/base/collection-view'
template = require 'views/templates/projects'
View = require 'views/project-view'
mediator = require 'mediator'

module.exports = class ProjectsView extends CollectionView
  itemView: View
  autoRender: true
  listSelector: '#project-list'
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) ->
    super
    console.log 'initializing projects view'
    mediator.setActive 'projects'

  render: =>
    super
    console.log 'rendering projects view'
