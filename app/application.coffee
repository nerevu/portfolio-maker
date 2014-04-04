mediator = require 'mediator'
Pages = require 'models/pages'
Blog = require 'models/blog'
Portfolio = require 'models/portfolio'
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
    mediator.portfolio.fetch().done (response) =>
      if response.message then return
      console.log 'done fetching portfolio'
      @publishEvent 'portfolio:synced', response
      store = "#{config.title}:#{mediator.portfolio.storeName}"
      localStorage.setItem "#{store}:synced", true
    mediator.gallery.fetch().done (response) =>
      console.log 'done fetching gallery'
      @publishEvent 'gallery:synced', response
      store = "#{config.title}:#{mediator.gallery.storeName}"
      localStorage.setItem "#{store}:synced", true

    super

  # Create additional mediator properties.
  initMediator: =>
    # Add additional application-specific properties and methods
    utils.log 'initializing mediator'
    mediator.pages = new Pages()
    mediator.blog = new Blog()
    mediator.portfolio = new Portfolio()
    mediator.gallery = new Gallery()

    mediator.active = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    mediator.main = {href: '/', title: 'Home'}
    mediator.seal()
    super
