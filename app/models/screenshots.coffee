Collection = require 'models/flickr'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Screenshots extends Collection
  type = 'screenshots'

  type: type
  preload: false
  storeName: "#{config.title}:#{type}"
