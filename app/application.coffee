mediator = require 'mediator'
config= require 'config'
Pages = require 'models/pages'

# The application object.
module.exports = class Application extends Chaplin.Application
  title: config.title
  meta:
    description: config.description
    keywords: config.keywords
    author: config.author

  # start: ->
  #   # You can fetch some data here and start app
  #   # (by calling `super`) after that.
  #   super

  # Create additional mediator properties.
  initMediator: =>
    # Add additional application-specific properties and methods
    console.log 'initializing mediator'
    pages = new Pages()

    mediator.active = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    # mediator.posts.set postData
    mediator.pageData = pages.fetch()
    mediator.main = {href: '/', title: 'Home'}
    mediator.seal()
    super
