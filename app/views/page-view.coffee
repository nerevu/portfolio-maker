View = require 'views/base/view'
Posts = require 'models/posts'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PageView extends View
  autoRender: true
  className: 'row'
  region: 'content'

  collection = new Posts()
  collection.set mediator.postData
  collection: collection

  listen:
#     'all': (event) => console.log "heard #{event}"
    'addedToParent': => console.log "heard addedToParent"

  initialize: (options) =>
    super
    template = @model.get 'template'
    @template = require "views/templates/#{template}"
    title = @model.get 'title'
    mediator.setActive title
    utils.log "initializing #{title} page view"

  render: =>
    super
    console.log "rendering page view"
    console.log @recent_posts

  getTemplateData: =>
    @collection.comparator = (model) -> - model.get 'date'
    @collection.sort()

    recent_posts = @collection.slice 0, config.recent_posts
    templateData = super
    templateData.recent_posts = []

    while model = recent_posts.shift()
      href = model.get 'href'
      title = model.get 'title'
      templateData.recent_posts.push({href: href, title: title})

    templateData

