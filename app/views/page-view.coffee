View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PageView extends View
  autoRender: true
  className: 'row'
  region: 'content'

  listen:
#     'all': (event) => console.log "heard #{event}"
    'addedToParent': => console.log "heard addedToParent"

  initialize: (options) =>
    super
    template = @model.get 'template'
    @template = require "views/templates/#{template}"
    title = @model.get 'title'
    mediator.setActive title
    utils.log "initializing #{title} page view"
    @listenTo @model, 'change', =>
      console.log "heard model change"
      @render()

  render: =>
    super
    console.log "rendering page view"
