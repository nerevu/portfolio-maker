Model = require 'models/file'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Page extends Model
	# load md file as a model
  initialize: ->
    super
    utils.log "initialize #{@get 'name'} page model"
    type = 'post'
    @set type: type
    @set slug: _.str.slugify @get 'name'
    @set href: "/#{@get 'slug'}"
    @set template: @get('template') ? 'item'
    @set partial: @get('partial') ? type
    @set nav_link: @get('nav_link') ? true
    @set asides: @get('asides') ? config.pages.asides
    @set sidebar: @get('sidebar') ? config.pages.sidebar
    @set collapsed: @get('collapsed') ? config.pages.collapsed
