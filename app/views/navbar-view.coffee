CollectionView = require 'views/base/collection-view'
template = require 'views/templates/navbar'
View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class NavbarView extends CollectionView
  itemView: View
  autoRender: true
  className: 'container'
  region: 'navbar'
  template: template
  listen: 'activeNav mediator': 'render'

  initialize: (options) =>
    super
    utils.log 'initializing navbar view'
    links = config.generated_pages
    console.log '-------------'
    console.log _.pluck config.generated_pages, 'title'
    console.log _.pluck links, 'title'

    _.each @collection.models, (model) ->
      if model.get 'nav_link'
        console.log _.pluck links, 'title'
        href = model.get 'href'
        title = model.get 'title'
        links.push({href: href, title: title})

    @links = links

  render: =>
    super
    utils.log 'rendering navbar view'

  getTemplateData: =>
    templateData = super
    templateData.main = mediator.main
    templateData.links = @links
    templateData
