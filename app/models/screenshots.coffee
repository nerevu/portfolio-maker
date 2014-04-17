Collection = require 'models/flickr'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Screenshots extends Collection
  type = 'screenshots'

  type: type
  storeName: _.str.capitalize type
  initialize: => super
