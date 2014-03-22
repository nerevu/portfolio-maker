CollectionView = require 'views/base/collection-view'
template = require 'views/templates/navbar'
View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'

module.exports = class NavbarView extends CollectionView
  itemView: View
  autoRender: true
  className: 'container'
  region: 'navbar'
  template: template
  listen: 'activeNav mediator': 'render'

  initialize: (options) =>
    super
    console.log 'initializing navbar view'

  render: =>
    super
    console.log 'rendering navbar view'

  getTemplateData: =>
    templateData = super
    templateData.main = mediator.main
    templateData.links = config.generated_pages

    while model = @collection.shift()
      if model.get 'nav_link'
        href = model.get 'href'
        title = model.get 'title'
        templateData.links.push({href: href, title: title})

    templateData
