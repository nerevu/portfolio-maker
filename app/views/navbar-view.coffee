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
    # union = _.union @collection, config.generated_pages
    union = config.generated_pages
    hrefs = _.pluck union, 'href'
    titles = _.pluck union, 'title'
    zipped = _.zip hrefs, titles
    templateData.main =  mediator.main
    templateData.links = (
      _.object ['href', 'title'], values for values in zipped)

    templateData