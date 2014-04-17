SiteView = require 'views/site-view'
NavbarView = require 'views/navbar-view'
FooterView = require 'views/footer-view'
config = require 'config'
utils = require 'lib/utils'
mediator = require 'mediator'

module.exports = class Controller extends Chaplin.Controller
  blog: mediator.blog
  portfolio: mediator.portfolio
  pages: mediator.pages
  gallery: mediator.gallery
  screenshots: mediator.screenshots

  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: (params, route) =>
    utils.log "controller beforeAction"
    @reuse 'site', SiteView
    @reuse 'footer', FooterView
    @reuse 'navbar', => @view = new NavbarView {collection: @pages}
