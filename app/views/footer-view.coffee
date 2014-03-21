View = require 'views/base/view'
template = require 'views/templates/site-footer'
mediator = require 'mediator'
config = require 'config'

module.exports = class FooterView extends View
  autoRender: true
  className: 'container'
  region: 'footer'
  template: template

  initialize: (options) =>
    super
    console.log 'initializing footer view'

  render: =>
    super
    console.log 'rendering footer view'

  getTemplateData: =>
    templateData = super
    templateData.author = config.author
    templateData.year = new Date().getFullYear()
    templateData
    
