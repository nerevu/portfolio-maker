Controller = require 'controllers/base/controller'
Collection = require 'models/base/collection'
DetailView = require 'views/detail-view'
MainView = require 'views/main-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class SiteController extends Controller
  initialize: (params) =>
    @num = parseInt params?.num ? 1
    @type = params?.type ? 'home'
    @sub_type = config[@type]?.sub_type ? ''
    @sub_title = config[@type]?.sub_title ? ''
    @tag = params?.tag
    @id = params?.id

    utils.log "initializing #{@type}'s site-controller"
    recent_comparator = config[@type]?.recent_comparator

    collection =
      switch @type
        when 'gallery' then @gallery
        when 'portfolio'
          @portfolio.mergePortfolio @screenshots
          @portfolio
        when 'blog' then @blog
        else @pages

    fltr = config[@type]?.filterer

    if fltr
      @filterer = (model, index=false) ->
        model.get(fltr.key) is fltr.value
    else
      @filterer = null

    if @tag
      @tagfilterer = (model, index=false) =>
        returned = if fltr then (model.get(fltr.key) is fltr.value) else true
        tags = _.union @tag.split('&')
        intersection = _(tags).intersection(model.get('tags') ? [])
        matched = tags.length is intersection.length
        returned and matched
    else
      @tagfilterer = @filterer

    if @type in @pages.pluck 'name'
      utils.log "#{@type} is a model"
      @find_where = name: @type
      @is_model = true
    else
      utils.log "#{@type} is a collection"

      if @id
        @find_where = {}
        @find_where[config[@type].identifier] = @id

      @is_model = false
      @recent = collection.recent
      @popular = collection.popular
      @random = collection.random
      @tags = collection.getTags @filterer
      @active = _.str.capitalize @type

    if recent_comparator
      collection.comparator = (model) -> - model.get recent_comparator
      collection.sort()

    @paginator = collection.paginator @num, @tagfilterer
    @collection = collection.clone()

  show: (params) => @reuse "#{@type}:#{@id}", =>
    utils.log "show #{@type} #{@id} site-controller"
    model = @collection.findWhere @find_where
    @collection.setPagers @filterer
    @collection.type = @type
    title = model?.get 'title'
    utils.log @collection, 'debug'

    @adjustTitle title
    @view = new DetailView
      model: model
      id: @id
      active: @active
      title: title
      pager: config[@type].show_pager
      recent: @recent
      popular: @popular
      random: @random
      related: @collection.getRelated model
      type: @type
      sub_type: @sub_type

  index: (params) => @reuse "#{@type}:index:#{@tag}:#{@num}", =>
    utils.log "index #{@type} site-controller"

    if @is_model
      model = @collection.findWhere @find_where
      title = model?.get 'title'
      @adjustTitle title

      @view = new DetailView
        model: model
        active: title
        title: title

    else
      title = "My #{@sub_title}#{@active}"
      @adjustTitle title

      @view = new MainView
        collection: @paginator.collection
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

  archives: (params) => @reuse "#{@type}:archives", =>
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
