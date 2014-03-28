Model = require 'models/base/model'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Photo extends Model
# sizes/t/
# sizes/s/
# sizes/m/
# sizes/l/

  sync: (method, model, options) =>
    # if model?.collection?
    model.local = -> method isnt 'read'
    Backbone.sync(method, model, options)

  initialize: (options) ->
    super
    name = @get('id')
    utils.log "initialize #{name} photo model"
    console.log @
    created = moment @get 'datetaken'
    updated = created

    @set first: false
    @set last: false
    @set href: "/gallery/#{name}"
    @set template: 'item'
    @set partial: @get('type')
    @set asides: config.gallery.page_asides
    @set sidebar: config.gallery.page_sidebar
    @set collapsed: config.gallery.page_collapsed
    @set created: created
    @set updated: updated
    @set created_str: created.format("MMMM Do, YYYY")
    @set updated_str: updated.format("MMMM Do, YYYY")
