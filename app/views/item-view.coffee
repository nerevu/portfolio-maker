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
    @template = require "views/templates/#{@model.get 'template'}"
    @recent_projects = options.recent_projects
    @recent_posts = options.recent_posts
    @recent_photos = options.recent_photos
    @title = options.title
    @pager = options.pager
    mediator.setActive options.active
    utils.log "initializing #{@model.get 'title'} item view"

  render: =>
    super
    utils.log "rendering item view"

  getTemplateData: =>
    utils.log 'get item view template data'
    templateData = super
    templateData.page_title = @title
    templateData.pager = @pager
    templateData.recent_projects = @recent_projects
    templateData.recent_posts = @recent_posts
    templateData.recent_photos = @recent_photos
    templateData.partial = @model.get 'partial'
    templateData

