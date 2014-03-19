Collection = require 'models/base/collection'
Model = require 'models/project'
config = require 'config'

module.exports = class Projects extends Collection
  model: Model

  initialize: (login) =>
    super
    console.log "initialize projects collection"
    @url = -> "https://api.github.com/users/reubano/repos"
