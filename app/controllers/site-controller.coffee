Controller = require 'controllers/base/controller'
Collection = require 'models/base/collection'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
ArchivesView = require 'views/archives-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class PageController extends Controller
  initialize: (params) =>
    utils.log 'initialize page-controller'
    get_recent = true
    @type = params?.type ? 'home'
    @id = params.id
    identifier = config[@type]?.identifier
    if identifier
      @find_where = {}
      @find_where[identifier] = @id

    switch @type
      when 'gallery'
        collection = @photos
        @sub_title = 'Photo '
        @sub_type = 'photos'
      when 'portfolio'
        collection = @projects
        @sub_title = 'Project '
        @sub_type = 'projects'
      when 'blog'
        collection = @posts
        @sub_title = ''
        @sub_type = 'posts'
      else
        collection = @pages
        @sub_title = ''
        @sub_type = ''
        get_recent = false

    filterer = config[@type]?.filterer

    if filterer
      console.log 'filterer'
      key = _.keys(filterer)[0]
      value = _.values(filterer)[0]
      @filterer = (item, index) -> item.get(key) is value
      @pager_filterer = filterer
    else
      @filterer = null
      @pager_filterer = null

    if get_recent
      console.log 'filterer'
      @recent = collection.getRecent @type, filterer
    # @popular = collection.getPopular @type, filterer
      console.log @recent

    @active = _.str.capitalize @type
    comparator = config[@type]?.comparator

    if comparator
      collection.comparator = (model) -> - model.get comparator
      collection.sort()

    @collection = collection.toJSON()

  show: (params) =>
    utils.log "show #{@type} #{@id} page-controller"
    collection = new Collection @collection
    collection.setPagers @pager_filterer
    model = collection.findWhere @find_where
    title = model.get 'title'

    @adjustTitle title
    @view = new ItemView
      model: model
      active: @active
      title: title
      pager: config[@type].show_pager
      recent: @recent
      type: @type
      sub_type: @sub_type

  index: (params) =>
    utils.log "index #{@type} page-controller"
    collection = new Collection @collection

    if @type in @pages.pluck 'name'
      utils.log "#{@type} is a model"
      model = collection.findWhere({name: @type})
      title = model.get 'title'
      @adjustTitle title

      @view = new ItemView
        model: model
        active: title
        title: title
        recent_posts: @posts.getRecent 'blog'
        recent_projects: @projects.getRecent 'portfolio', {fork: false}
        recent_photos: @photos.getRecent 'gallery'

    else
      utils.log "#{@type} is a collection"
      console.log @recent
      title = "My #{@sub_title}#{@active}"
      num = parseInt params?.num ? 1
      per = config[@type]?.items_per_index
      paginator = if per then collection.paginator per, num else {}
      @adjustTitle title

      @view = new IndexView
        collection: paginator?.collection
        pages: paginator.pages
        filterer: @filterer
        first_page: paginator?.first_page
        last_page: paginator?.last_page
        cur_page: num
        next_page: num + 1
        prev_page: num - 1
        active: @active
        title: title
        recent: @recent
        # popular: @popular
        type: @type
        sub_type: @sub_type
        class: config[@type].index_class

  archives: (params) =>
    utils.log "archives #{@type} page-controller"
    collection = new Collection @collection
    active = 'Archives'
    title = "#{@active} Archives"
    @adjustTitle title
    years = collection.pluck 'year'
    year_months = collection.pluck 'year_month'

    setShowYear = (year) ->
      model = collection.findWhere year: year
      count = (y for y in years when y is year).length
      model.set show_year: true
      model.set year_rowspan: count

    setShowMonth = (year_month) ->
      model = collection.findWhere year_month: year_month
      count = (y for y in year_months when y is year_month).length
      model.set show_month: true
      model.set month_rowspan: count

    _.each _.uniq(years), setShowYear, @
    _.each _.uniq(year_months), setShowMonth, @

    @view = new ArchivesView
      collection: collection
      active: active
      title: title
      recent: @recent
      type: @type
      sub_type: @sub_type
