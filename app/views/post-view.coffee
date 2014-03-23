View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PostView extends View
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
    mediator.setActive options.active
    utils.log "initializing #{title} post view"

  render: =>
    super
    console.log "rendering post view"

  getTemplateData: =>
    templateData = super
    templateData.page_title = @title
    templateData
