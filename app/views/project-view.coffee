View = require 'views/base/view'
template = require 'views/templates/project'

module.exports = class ProjectView extends View
  autoRender: false
  tagName: 'tr'
  template: template

  listen:
#     'all': (event) => console.log "heard #{event}"
    'addedToParent': => console.log "heard addedToParent"

  initialize: (options) =>
    super
    @listenTo @model, 'change', =>
      console.log "heard model change"
      @render()

    @id = @model.get('id')
    @login = @model.get('login')
    if @id then console.log "initializing project view for id #{@id}"
    else if @login then console.log "initializing project view for #{@login}"
    else return

  render: =>
    super
    console.log "rendering project view"
