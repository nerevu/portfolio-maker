Controller = require 'controllers/base/controller'
Model = require 'models/user'
View = require 'views/home-view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class HomeController extends Controller
  initialize: =>
    @adjustTitle 'Home'
    utils.log 'initialize home-controller'

  show: (params) =>
    console.log 'home controller'
    # Initialize new user with login from URL params.
    login = params?.login ? config.login
    @model = new Model login: login
    @view = new View {@model}
    @model.fetch()
