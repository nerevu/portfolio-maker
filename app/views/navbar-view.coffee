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

    _.each @collection.models, (model) ->
      if model.get 'nav_link'
        href = model.get 'href'
        title = model.get 'title'
        links.push({href: href, title: title})

    @links = links

  render: =>
    super
    utils.log 'rendering navbar view'

  getTemplateData: =>
    utils.log 'get navbar view template data'
    templateData = super
    templateData.main = mediator.main
    templateData.links = @links
    templateData.site = config.site
    templateData
