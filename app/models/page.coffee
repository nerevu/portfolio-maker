Model = require 'models/file'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Page extends Model
	# load md file as a model
  initialize: =>
    super
    name = @get 'name'
    slug = _.str.slugify name
    utils.log "initialize #{name} page model"
    type = 'page'
    @set type: type
    @set slug: slug
    @set href: "/#{slug}"
    @set template: @get('template') ? 'item'
    @set partial: @get('partial') ? type
    @set nav_link: @get('nav_link') ? true
    @set asides: @get('asides') ? config.pages.asides
    @set sidebar: @get('sidebar') ? config.pages.sidebar
    @set collapsed: @get('collapsed') ? config.pages.collapsed
