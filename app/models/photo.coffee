Model = require 'models/base/model'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Photo extends Model
  initialize: (attrs, options) =>
    super
    id = @get 'id'
    title = @get('title') or 'Untitled'
    name = title
    type = options?.collection_type
    sub_type = @get 'media'
    # utils.log "initialize #{name} #{sub_type} model"
    # console.log @

    try
      tags = @get('tags').split(' ')
    catch TypeError
      tags = @get('tags')

    tags = if _(tags).any() then tags else ['untagged']
    dms = utils.deg2dms @get('latitude'), @get('longitude')
    dms_str = "#{dms.lat.deg}° #{dms.lat.min}' #{dms.lat.sec}\" #{dms.lat.dir}"
    dms_str += "<br>"
    dms_str += "#{dms.lon.deg}° #{dms.lon.min}' #{dms.lon.sec}\" #{dms.lon.dir}"
    created = moment @get 'datetaken'
    updated = created

    @set first: false
    @set last: false
    @set type: type
    @set sub_type: sub_type
    @set tags: tags
    @set href: "/#{type}/item/#{id}"
    @set url_e: @get 'url_m'
    @set dms: dms
    @set dms_str: dms_str
    @set name: name
    @set title: title
    @set template: 'item'
    @set partial: sub_type
    @set asides: config[type]?.page_asides
    @set sidebar: config[type]?.page_sidebar
    @set collapsed: config[type]?.page_collapsed
    @set created: created
    @set updated: updated
    @set created_str: created.format("MMMM Do, YYYY")
    @set updated_str: updated.format("MMMM Do, YYYY")
    @save patch: true
