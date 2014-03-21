SiteView = require 'views/site-view'
Navbar = require 'models/pages'
NavbarView = require 'views/navbar-view'
mediator = require 'mediator'
config = require 'config'

module.exports = class Controller extends Chaplin.Controller
  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: (params, route) =>
    console.log "controller beforeAction"
    login = params?.login ? config.login
    @compose 'site', SiteView
    @compose 'navbar', ->
      @collection = new Navbar()
      mediator.title = mediator.main.title
      data = @collection.fetch()
      @collection.set data
      @view = new NavbarView {@collection}
