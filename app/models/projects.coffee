Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Projects extends Collection
  model: Model

  initialize: =>
    super
    @url = -> "https://api.github.com/users/reubano/repos"
    utils.log "initialize projects collection"
