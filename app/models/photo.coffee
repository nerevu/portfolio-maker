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
    id = @get 'id'
    title = @get('title') or 'Untitled'
    name = title
    type = @get 'media'
    # console.log @

    try
      tags = @get('tags').split(' ')
    catch TypeError
      null

    tags = if _(tags).any() then tags else ['untagged']
    dms = utils.deg2dms @get('latitude'), @get('longitude')
    dms_str = "#{dms.lat.deg}° #{dms.lat.min}' #{dms.lat.sec}\" #{dms.lat.dir}"
    dms_str += "<br>"
    dms_str += "#{dms.lon.deg}° #{dms.lon.min}' #{dms.lon.sec}\" #{dms.lon.dir}"
    utils.log "initialize #{name} photo model"
    created = moment @get 'datetaken'
    updated = created

    @set first: false
    @set last: false
    @set type: type
    @set tags: tags
    @set href: "/gallery/item/#{id}"
    @set dms: dms
    @set dms_str: dms_str
    @set name: name
    @set title: title
    @set template: 'item'
    @set partial: type
    @set asides: config.gallery.page_asides
    @set sidebar: config.gallery.page_sidebar
    @set collapsed: config.gallery.page_collapsed
    @set created: created
    @set updated: updated
    @set created_str: created.format("MMMM Do, YYYY")
    @set updated_str: updated.format("MMMM Do, YYYY")
