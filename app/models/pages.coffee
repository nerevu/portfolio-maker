require 'shelljs/global'

Collection = require 'models/base/collection'
Model = require 'models/page'
config = require 'config'
matter = require 'gray-matter'
marked = require 'marked'
md5 = require 'md5'

module.exports = class Pages extends Collection
  model: Model
	url = -> "views/pages/"

  initialize: =>
    super
    console.log "initialize pages collection"

  parse: (response, options) =>
		cb = (err, content) ->
		  if (err) throw err
		  console.log(content)

		cd @url
		all_md = (cat file for file in ls '*.md')
		all_matter = (matter md for md in all_md)

		for obj in all_matter
			obj.id = md5(obj.original)
		
		all_matter.toJSON()
