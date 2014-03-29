Controller = require 'controllers/base/controller'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PhotoController extends Controller
  type: 'gallery'

  initialize: =>
    utils.log 'initialize photo-controller'
    @active = _.str.capitalize @type
    @photos.comparator = (model) -> - model.get 'created'
    @photos.sort()
    @recent_photos = @photos.getRecent @type
    @photos.setPagers()

  show: (params) =>
    id = params.id
    utils.log "show #{id} photo-controller"
    title = @photos.findWhere({id: id}).get 'title'
    @adjustTitle title
    @view = new ItemView
      model: @photos.findWhere({id: id})
      active: @active
      title: title
      pager: true
      recent_photos: @recent_photos

  index: (params) =>
    num = params?.num ? 1
    per = config[@type].items_per_index
    utils.log "index photo-controller"
    title = "My Photo #{@active}"
    # paginator = @photos.paginator per, num
    # console.log paginator
    @adjustTitle title

    @view = new IndexView
      # collection: paginator.collection
      # pages: paginator.pages
      collection: @photos
      num: num
      # first_page: paginator.first_page
      # last_page: paginator.last_page
      active: @active
      title: title
      recent_photos: @recent_photos
      type: @type
      class: 'col-sm-6 col-md-4'

