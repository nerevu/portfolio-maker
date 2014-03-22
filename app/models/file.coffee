Model = require 'models/base/model'

module.exports = class File extends Model
  # load md file as a model
  initialize: =>
    super
    console.log "initialize file model"
    @set sidebar: if @has('sidebar') then @get('sidebar') else true
    @set content: @get 'html'
    @set ctime: new Date()
    @set mtime: new Date()

