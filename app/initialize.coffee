Application = require 'application'
routes = require 'routes'
mediator = require 'mediator'

window.onLoadGoogleApiCallback = ->
  L.GeoSearch.Provider.Google.Geocoder = new google.maps.Geocoder()
  document.body.removeChild(document.getElementById('load_google_api'))
  mediator.publish 'googleLoaded'
  mediator.googleLoaded = true
  console.log 'published googleLoaded'

# Initialize the application on DOM ready event.
$ ->
  console.log 'initializing app'
  new Application {
    controllerSuffix: '-controller'
    routes: routes
    pushState: false
  }
