Model = require 'models/base/model'

module.exports = class File extends Model
  # load md file as a model
  initialize: (options) =>
    super
    console.log "initialize file model"
    @set ctime: new Date()
    @set mtime: new Date()
    # @set slug: _s.slugify @get 'name'
    @set slug: @get 'name'
    @set href: "/#{@get 'slug'}"

