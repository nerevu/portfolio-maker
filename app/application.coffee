# Posts = require 'models/posts'
mediator = require 'mediator'
Pages = require 'models/pages'
Posts = require 'models/posts'
utils = require 'lib/utils'

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
    utils.log 'initializing mediator'
    pages = new Pages()
    posts = new Posts()

    mediator.active = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    mediator.postData = posts.fetch()
    mediator.pageData = pages.fetch()
    mediator.main = {href: '/', title: 'Home'}
    mediator.seal()
    super
