Model = require 'models/base/model'
# marked = require 'marked'

module.exports = class aFile extends Model
	# load md file as a model
  initialize: (options) =>
    super
    console.log "initialize file model"
		# @set html: marked obj.content, cb
		# @set filename: file
		# @set ctime: new Date()
		# @set mtime: new Date()
		# @set slug: obj.context?.slug ? @slug_from_filename(file)

