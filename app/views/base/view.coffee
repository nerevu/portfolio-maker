config = require 'config'
mediator = require 'mediator'
require 'lib/view-helper' # Just load the view helpers, no return value

module.exports = class View extends Chaplin.View
  # Auto-save `template` option passed to any view as `@template`.
  optionNames: Chaplin.View::optionNames.concat ['template']

  # Precompiled templates function initializer.
  getTemplateFunction: ->
    @template

  codeLocation: (map, location, login, tmp=false) =>
    options = {}
    _.extend options, config.options
    _.extend options, tmp
    options.provider = new config.srchProviders[options.srchProviderName]()
    if not location? then return console.log "#{login} has no location"
    console.log "coding location: #{location} with #{options.srchProviderName}"
    markers = options.markers
    icon = L.AwesomeMarkers.icon options
    tileProvider = config.tileProviders[options.tileProvider]
#
#     if options.tileProvider is 4
#       url = "http://auth.cloudmade.com/token/#{config.cm_api_key}"
#       data = {userid: 'reubano', deviceid: 'deviceid'}
#       setURL = (data, textStatus, res) ->
#         console.log 'setting url'
#         url = "#{L.TileLayer.Provider.providers.CloudMade.url}?token=#{data}"
#         _.extend L.TileLayer.Provider.providers.CloudMade, {url: url}
#         @continue map, location, login, options
#
#       failWhale = (res, textStatus, err) ->
#         try
#           error = JSON.parse(res.responseText).error
#         catch error
#           error = res.responseText
#         console.log textStatus
#
#       post = (url, data) -> $.ajax
#         type: "POST"
#         url: url
#         data: data
#         dataType: 'text'
#
#       post(url, data).done(setURL).fail(failWhale)
#
#     else @continue map, location, login, options
#
#   continue: (map, location, login, options) =>
    L.tileLayer.provider(tileProvider, options.tpOptions).addTo(map)
    map.setView(options.center, options.zoomLevel, false) if options.center
#     map.on 'click', (e) -> console.log 'map.setView e.latlng, 2, false'

    L.Control.GeoSearch = L.Control.GeoSearch.extend
      _showLocation: (coordinates) ->
        marker = L.marker([coordinates.Y, coordinates.X], {icon: icon}).addTo(map)
        marker.bindPopup "#{login}: #{location}"
        marker.on 'mouseover', (e) -> e.target.openPopup()
        marker.on 'mouseout', (e) -> e.target.closePopup()
        markers.addLayer(marker) if markers
        mediator.publish 'geosearchLocated', coordinates
        map.fireEvent 'geosearch_showlocation', {Location: coordinates}

    @subscribeEvent 'geosearchLocated', (loc) =>
      console.log 'heard geosearchLocated'
      map.setView([loc.Y, loc.X], options.zoomLevel, false) if not options.center

    search = new L.Control.GeoSearch options
    search.addTo map
    google = options.srchProviderName.indexOf('google') is 0
    if google and mediator.googleLoaded then search.geosearch location
    else if google then @subscribeEvent 'googleLoaded', -> search.geosearch location
    else search.geosearch location

