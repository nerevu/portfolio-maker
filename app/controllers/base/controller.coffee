SiteView = require 'views/site-view'
NavbarView = require 'views/navbar-view'
FooterView = require 'views/footer-view'
config = require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class Controller extends Chaplin.Controller
  posts: mediator.posts
  projects: mediator.projects
  pages: mediator.pages

  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: (params, route) =>
    utils.log "controller beforeAction"
    @compose 'site', SiteView
    @compose 'footer', FooterView
    @compose 'navbar', =>
      @view = new NavbarView {collection: @pages}
