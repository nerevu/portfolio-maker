View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ExcerptView extends View
  region: 'content'

  initialize: (options) =>
    super
    utils.log 'initializing excerpt-view'
    @listenTo @model, 'change', @render
    @listenTo @model, 'change:tags', => @publishEvent "change:tags"