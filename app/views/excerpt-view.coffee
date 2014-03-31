View = require 'views/base/view'
utils = require 'lib/utils'
config = require 'config'

module.exports = class ExcerptView extends View
  autoRender: true

  listen:
#     'all': (event) => utils.log "heard #{event}"
    'addedToParent': => utils.log "heard addedToParent"

  initialize: (options) =>
    super
    @name = @model.get 'name'
    @type = @model.get 'type'
    @sub_type = @model.get 'sub_type'
    utils.log "initializing excerpt view for #{@name}"
    @template = require "views/templates/#{@sub_type}-excerpt"

  render: =>
    super
    utils.log "rendering excerpt view for #{@name}"
