Model = require 'models/base/model'

module.exports = class Page extends Model
	# load md file as a model
  initialize: (file) =>
    super
    console.log "initialize file model"
		@set html: marked obj.content, cb
		@set filename: file
		@set ctime: new Date()
		@set mtime: new Date()
		@set slug: obj.context?.slug or @slug_from_filename(file)
		@set title: obj.context.title
		@set sidebar: obj.context?.sidebar or true
		@set comments: obj.context?.comments or true
		@set sharing: obj.context?.sharing or true
		@set footer: obj.context?.footer or true
