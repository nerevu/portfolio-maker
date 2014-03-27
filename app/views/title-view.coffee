View = require 'views/base/view'
template = require 'views/templates/title'
utils = require 'lib/utils'

module.exports = class TitleView extends View
  autoRender: true
  tagName: 'tr'
  template: template

  listen:
#     'all': (event) => utils.log "heard #{event}"
    'addedToParent': => utils.log "heard addedToParent"

  initialize: (options) =>
    super
    utils.log "initializing title view"

  render: =>
    super
    utils.log "rendering title view"
