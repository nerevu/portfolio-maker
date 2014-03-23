View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class ItemView extends View
  autoRender: true
  className: 'row'
  region: 'content'

  listen:
#     'all': (event) => utils.log "heard #{event}"
    'addedToParent': => utils.log "heard addedToParent"

  initialize: (options) =>
    super
    template = @model.get 'template'
    @template = require "views/templates/#{template}"
    @recent_projects = options.recent_projects
    @recent_posts = options.recent_posts
    @title = options.title
    mediator.setActive options.active
    utils.log "initializing #{@model.get 'title'} item view"

  render: =>
    super
    utils.log "rendering item view"

  getTemplateData: =>
    templateData = super
    templateData.page_title = @title
    templateData.recent_projects = @recent_projects
    templateData.recent_posts = @recent_posts
    templateData

