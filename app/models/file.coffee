Model = require 'models/base/model'
utils = require 'lib/utils'

module.exports = class File extends Model
  # load md file as a model
  initialize: =>
    super
    utils.log "initialize #{@get 'name'} file model"
    @set sidebar: if @has('sidebar') then @get('sidebar') else true
    @set content: @get 'html'
    @set ctime: new Date()
    @set mtime: new Date()

