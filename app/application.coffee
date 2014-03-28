# Posts = require 'models/posts'
mediator = require 'mediator'
Pages = require 'models/pages'
Posts = require 'models/posts'
Projects = require 'models/projects'
Photos = require 'models/photos'
config= require 'config'
utils = require 'lib/utils'

# The application object.
module.exports = class Application extends Chaplin.Application
  title: config.title
  meta:
    description: config.description
    keywords: config.keywords
    author: config.author

  start: ->
    # You can fetch some data here and start app
    # (by calling `super`) after that.
    mediator.pages.fetch()
    mediator.posts.fetch()
    mediator.projects.fetch().done (response) ->
      if response.message then return
      localStorage.setItem "#{config.title}:Projects:synced", true
    mediator.photos.fetch().done (response) ->
      console.log 'done fetching photos'
      localStorage.setItem "#{config.title}:Photos:synced", true
    super

  # Create additional mediator properties.
  initMediator: =>
    # Add additional application-specific properties and methods
    utils.log 'initializing mediator'
    mediator.pages = new Pages()
    mediator.posts = new Posts()
    mediator.projects = new Projects()
    mediator.photos = new Photos()

    mediator.active = null
    mediator.googleLoaded = null
    mediator.map = null
    mediator.markers = null
    mediator.doneSearching = null
    mediator.main = {href: '/', title: 'Home'}
    mediator.seal()
    super
