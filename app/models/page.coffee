Model = require 'models/file'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Page extends Model
	# load md file as a model
  initialize: (attrs, options)=>
    super
    name = @get 'name'
    type = options.type
    sub_type = config[type].sub_type
    # utils.log "initializing #{name} #{sub_type} model"
    slug = _.str.slugify name

    @set type: type
    @set sub_type: sub_type
    @set slug: slug
    @set href: "/#{slug}"
    @set template: @get('template') ? 'item'
    @set partial: @get('partial') ? sub_type
    @set nav_link: @get('nav_link') ? true
    @set asides: @get('asides') ? config[type].asides
    @set sidebar: @get('sidebar') ? config[type].sidebar
    @set collapsed: @get('collapsed') ? config[type].collapsed
