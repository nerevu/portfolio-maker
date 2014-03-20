Model = require 'models/file'

module.exports = class Page extends Model
	# load md file as a model
  initialize: (file) ->
    super
    console.log "initialize page model"
    # @set template: obj.context?.template ? 'page'
    # @set date: @get ctime
    # @set href: "/#{@get 'slug'}"
    # @set title: @get 'title'
