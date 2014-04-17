View = require 'views/base/view'
template = require 'views/templates/site-footer'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class FooterView extends View
  autoRender: true
  className: 'container'
  region: 'footer'
  template: template

  initialize: (options) ->
    super
    utils.log 'initializing footer view'

  render: ->
    super
    utils.log 'rendering footer view'

  getTemplateData: ->
    templateData = super
    templateData.author = config.author
    templateData.year = new Date().getFullYear()
    templateData

