Collection = require 'models/base/collection'
Model = require 'models/page'
config = require 'config'
# matter = require 'gray-matter'
# md5 = require 'md5'
# shelljs = require 'shelljs'

module.exports = class Pages extends Collection
  model: Model
  # url = -> "views/pages/"

  initialize: (file)=>
    super
    console.log "initialize pages collection"

  # parse: (response, options) =>
  #   cb = (err, content) ->
  #     throw err if (err) 
  #     console.log(content)
  # 
  #   cd @url
    # all_md = (shelljs.cat file for file in shelljs.ls '*.md')
    # all_matter = (matter md for md in all_md)
    # 
    # for obj in all_matter
    #   obj.id = md5(obj.original)
    # 
    # all_matter.toJSON()
