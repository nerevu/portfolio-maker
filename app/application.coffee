mediator = require 'mediator'
Pages = require 'models/pages'
Blog = require 'models/blog'
Portfolio = require 'models/portfolio'
Screenshots = require 'models/screenshots'
Gallery = require 'models/gallery'
config= require 'config'
utils = require 'lib/utils'

# The application object.
module.exports = class Application extends Chaplin.Application
  title: config.title
  meta:
    description: config.description
    keywords: config.keywords
    author: config.author

  start: =>
    # You can fetch some data here and start app
    # (by calling `super`) after that.
    mediator.pages.fetch()
    mediator.blog.fetch()
    for collection in ['portfolio', 'screenshots', 'gallery']
      do (collection) => mediator[collection].fetch().done (response) =>
        if response.message then return
        console.log "done fetching #{collection}"
        @publishEvent "#{collection}:synced", response
        store = "#{config.title}:#{mediator[collection].storeName}"
        if not mediator[collection].remote
          localStorage.setItem("#{store}:synced", true)
        utils.preloadImages response

    super

  # Create additional mediator properties.
  initMediator: ->
    # Add additional application-specific properties and methods
    utils.log 'initializing mediator'
    mediator.pages = new Pages()
    mediator.blog = new Blog()
    mediator.portfolio = new Portfolio()
    mediator.screenshots = new Screenshots()
    mediator.gallery = new Gallery()

    mediator.active = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    mediator.main = {href: '/', title: 'Home'}
    mediator.seal()
    super
