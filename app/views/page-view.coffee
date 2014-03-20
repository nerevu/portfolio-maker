View = require 'views/base/view'
template = require 'views/templates/page'
config = require 'config'

module.exports = class ContribView extends View
  autoRender: true
  template: template

  listen:
#     'all': (event) => console.log "heard #{event}"
    'addedToParent': => console.log "heard addedToParent"

  initialize: (options) =>
    super
    @listenTo @model, 'change', =>
      console.log "heard model change"
      @render()

  render: =>
    super
    console.log "rendering page view"

  getTemplateData: =>
    templateData = super
    templateData.asides =  @model.asides ? config.page_asides
    templateData