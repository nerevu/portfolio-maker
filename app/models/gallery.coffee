Collection = require 'models/flickr'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Gallery extends Collection
  type = 'gallery'

  type: type
  preload: true
  storeName: "#{config.title}:#{type}"
