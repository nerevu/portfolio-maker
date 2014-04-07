Controller = require 'controllers/base/controller'
Collection = require 'models/base/collection'
DetailView = require 'views/detail-view'
MainView = require 'views/main-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class SiteController extends Controller
  initialize: (params) =>
    utils.log 'initialize site-controller'
    @num = parseInt params?.num ? 1
    @type = params?.type ? 'home'
    @tag = params?.tag
    @id = params?.id
    recent_comparator = config[@type]?.recent_comparator
    identifier = config[@type]?.identifier

    if @id and identifier
      @find_where = {}
      @find_where[identifier] = @id

    switch @type
      when 'gallery'
        collection = @gallery
        @sub_title = 'Photo '
        @sub_type = 'photo'

      when 'portfolio'
        collection = @portfolio.mergeModels @screenshots, ['url_s'], 'small'
        collection = collection.mergeModels @screenshots, ['url_m'], 'main'
        collection = collection.mergeModels @screenshots, ['url_sq'], 'square'
        @sub_title = 'Project '
        @sub_type = 'project'

      when 'blog'
        collection = @blog
        @sub_title = ''
        @sub_type = 'post'

      else
        collection = @pages
        @sub_title = ''
        @sub_type = ''

    filterer = config[@type]?.filterer

    if filterer
      key = _.keys(filterer)[0]
      value = _.values(filterer)[0]
      @filterer = (model, index=false) => model.get(key) is value
    else
      @filterer = null

    if @tag
      @tagfilterer = (model, index=false) =>
        returned = if filterer then (model.get(key) is value) else true
        returned = returned and @tag in (model.get('tags') ? [])
        returned
    else
      @tagfilterer = @filterer

    if @type in @pages.pluck 'name'
      @model = collection.findWhere name: @type
    else if @id and identifier
      @model = collection.findWhere @find_where
      @related = collection.getRelated @model

    @recent = collection.getRecent()
    @popular = collection.getPopular()
    @random = collection.getRandom()
    @tags = collection.getTags @filterer
    @active = _.str.capitalize @type

    if recent_comparator
      collection.comparator = (model) -> - model.get recent_comparator
      collection.sort()

    @paginator = collection.paginator @num, @tagfilterer

  show: (params) =>
    utils.log "show #{@type} #{@id} site-controller"
    collection = @paginator.collection
    collection.setPagers @filterer
    title = model?.get 'title'

    @adjustTitle title
    @view = new DetailView
      model: @model
      active: @active
      title: title
      pager: config[@type].show_pager
      recent: @recent
      popular: @popular
      random: @random
      related: @related
      sub_type: @sub_type

  index: (params) =>
    utils.log "index #{@type} site-controller"
    collection = @paginator.collection

    if @type in @pages.pluck 'name'
      utils.log "#{@type} is a model"
      title = @model?.get 'title'
      @adjustTitle title

      @view = new DetailView
        model: @model
        active: title
        title: title

    else
      utils.log "#{@type} is a collection"
      title = "My #{@sub_title}#{@active}"
      @adjustTitle title

      @view = new MainView
        collection: collection
        paginator: @paginator
        filterer: @tagfilterer  # only show tagged items
        tagfilter: @filterer  # show tags for all site items
        cur_page: @num
        next_page: @num + 1
        prev_page: @num - 1
        active: @active
        title: title
        recent: @recent
        popular: @popular
        random: @random
        tags: @tags
        tag: @tag
        type: @type
        sub_type: @sub_type
        template: 'index'
        list_selector: '#excerpt-list'

  archives: (params) =>
    utils.log "archives #{@type} site-controller"
    collection = @paginator.collection
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

    @view = new MainView
      collection: collection
      paginator: @paginator
      active: active
      title: title
      recent: @recent
      type: @type
      sub_type: @sub_type
      template: 'archives'
      list_selector: '#archives-list'
