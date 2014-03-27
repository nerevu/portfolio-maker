# Posts = require 'models/posts'
mediator = require 'mediator'
Pages = require 'models/pages'
Posts = require 'models/posts'
Projects = require 'models/projects'
config= require 'config'
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
    mediator.pages = new Pages()
    mediator.posts = new Posts()
    mediator.projects = new Projects()

    mediator.active = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    mediator.pages.fetch()
    mediator.posts.fetch()
    mediator.projects.cltnFetch().done (response) ->
      if response.message then return
      localStorage.setItem "#{config.title}:synced", true
    mediator.main = {href: '/', title: 'Home'}
    mediator.seal()
    super
