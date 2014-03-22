View = require 'views/base/view'
template = require 'views/templates/excerpt'
utils = require 'lib/utils'

module.exports = class ExcerptView extends View
  autoRender: true
  className: 'row'
  # tagName: 'tr'
  region: 'content'
  template: template

  listen:
#     'all': (event) => console.log "heard #{event}"
    'addedToParent': => console.log "heard addedToParent"

  initialize: (options) =>
    super
    utils.log "initializing excerpt view"

  render: =>
    super
    utils.log "rendering excerpt view"
