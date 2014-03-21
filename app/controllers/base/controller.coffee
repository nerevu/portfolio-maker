SiteView = require 'views/site-view'
NavbarView = require 'views/navbar-view'
FooterView = require 'views/footer-view'
Pages = require 'models/pages'
config = require 'config'
mediator = require 'mediator'

module.exports = class Controller extends Chaplin.Controller
  # Compositions persist stuff between controllers.
  # You may also persist models etc.
  beforeAction: (params, route) =>
    console.log "controller beforeAction"
    @compose 'site', SiteView
    @compose 'footer', FooterView
    @compose 'navbar', =>
      collection = new Pages()
      collection.set mediator.pageData
      @view = new NavbarView {collection}
