Application = require 'application'
routes = require 'routes'
mediator = require 'mediator'
utils = require 'lib/utils'

window.onLoadGoogleApiCallback = ->
  L.GeoSearch.Provider.Google.Geocoder = new google.maps.Geocoder()
  $.remove 'load_google_api'
  mediator.publish 'googleLoaded'
  mediator.googleLoaded = true

# Initialize the application on DOM ready event.
$ ->
  utils.log 'initializing app'
  new Application {
    controllerSuffix: '-controller'
    routes: routes
    pushState: false
  }
