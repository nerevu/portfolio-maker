Model = require 'models/file'

module.exports = class Page extends Model
	# load md file as a model
  initialize: (file) ->
    super
    console.log "initialize page model"
    @set template: if @has('template') then @get('template') else 'page'
    @set nav_link: if @has('nav_link') then @get('nav_link') else true
