View = require 'views/base/view'
utils = require 'lib/utils'

module.exports = class ExcerptView extends View
  autoRender: true
  className: 'row'

  listen:
#     'all': (event) => utils.log "heard #{event}"
    'addedToParent': => utils.log "heard addedToParent"

  initialize: (options) =>
    super
    @name = @model.get 'name'
    @type = @model.get 'type'
    utils.log "initializing excerpt view for #{@name}"
    @template = require "views/templates/#{@type}-excerpt"

  render: =>
    super
    utils.log "rendering excerpt view for #{@name}"
