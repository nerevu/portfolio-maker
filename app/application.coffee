mediator = require 'mediator'
config= require 'config'

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
    mediator.active = null
    mediator.user = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    mediator.title = null
    mediator.main = {href: '/', title: @title}
    # Seal the mediator
    super
