Model = require 'models/file'
config = require 'config'

module.exports = class Page extends Model
	# load md file as a model
  initialize: ->
    super
    console.log "initialize #{@get 'name'} page model"
    @set type: 'page'
    @set slug: _.str.slugify @get 'name'
    @set href: "/#{@get 'slug'}"
    @set template: @get('template') ? 'page'
    @set nav_link: @get('nav_link') ? true
    @set asides: @get('asides') ? config.pages.asides
    @set sidebar: @get('sidebar') ? config.pages.sidebar
    @set collapsed: @get('collapsed') ? config.pages.collapsed
