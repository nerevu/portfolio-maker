Model = require 'models/file'

module.exports = class Post extends Model
	# load md file as a model
  initialize: (file) ->
    super
    console.log "initialize post model"
		@set template: obj.context?.template ? 'post'
		@set date: obj.context?.date ? @date_from_filename(file) ? new Date()
		@set comments: obj.context?.comments ? true
		@set tags: obj.context?.tags?.split(',') ? []
