Controller = require 'controllers/base/controller'
View = require 'views/home-view'
utils = require 'lib/utils'

module.exports = class HomeController extends Controller
  initialize: =>
    @adjustTitle 'Home'
    utils.log 'initialize home-controller'

  show: (params) =>
    console.log 'home controller'
    @view = new View()
