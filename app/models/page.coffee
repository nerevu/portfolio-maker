Model = require 'models/file'

module.exports = class Page extends Model
	# load md file as a model
  initialize: (file) ->
    super
    console.log "initialize page model"
    @set template: if @has('template') then @get('template') else 'page'
