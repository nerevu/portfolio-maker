View = require 'views/base/view'
utils = require 'lib/utils'

module.exports = class ExcerptView extends View
  autoRender: true
  className: 'row'

  listen:
#     'all': (event) => console.log "heard #{event}"
    'addedToParent': => console.log "heard addedToParent"

  initialize: (options) =>
    super
    utils.log "initializing excerpt view for #{@model.get 'name'}"
    @template = require "views/templates/#{@model.get 'type'}-excerpt"

  render: =>
    super
    utils.log "rendering excerpt view for #{@model.get 'name'}"
