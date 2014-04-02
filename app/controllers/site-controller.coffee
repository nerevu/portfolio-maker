Controller = require 'controllers/base/controller'
Collection = require 'models/base/collection'
ItemView = require 'views/item-view'
IndexView = require 'views/index-view'
config = require 'config'
utils = require 'lib/utils'

module.exports = class SiteController extends Controller
  initialize: (params) =>
    utils.log 'initialize site-controller'
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
        collection = @portfolio
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
      @filterer = (item, index=false) => item.get(key) is value
    else
      @filterer = null

    if @tag
      @tagfilterer = (item, index=false) =>
        returned = if filterer then (item.get(key) is value) else true
        returned = returned and @tag in (item.get('tags') ? [])
        returned
    else
      @tagfilterer = @filterer

    @recent = collection.getRecent @type
    @popular = collection.getPopular @type
    @random = collection.getRandom @type
    @active = _.str.capitalize @type

    if recent_comparator
      collection.comparator = (model) -> - model.get recent_comparator
      collection.sort()

    @collection = collection.toJSON()

  show: (params) =>
    utils.log "show #{@type} #{@id} site-controller"
    collection = new Collection @collection
    collection.setPagers @filterer
    model = collection.findWhere @find_where
    title = model?.get 'title'

    @adjustTitle title
    @view = new ItemView
      model: model
      active: @active
      title: title
      pager: config[@type].show_pager
      recent: @recent
      popular: @popular
      random: @random
      type: @type
      sub_type: @sub_type

  index: (params) =>
    utils.log "index #{@type} site-controller"
    collection = new Collection @collection

    if @type in @pages.pluck 'name'
      utils.log "#{@type} is a model"
      model = collection.findWhere({name: @type})
      title = model?.get 'title'
      @adjustTitle title

      @view = new ItemView
        model: model
        active: title
        title: title
        recent_posts: @blog.getRecent 'blog'
        recent_projects: @portfolio.getRecent 'portfolio'
        popular_projects: @portfolio.getPopular 'portfolio'
        recent_photos: @gallery.getRecent 'gallery'
        popular_photos: @gallery.getPopular 'gallery'

    else
      utils.log "#{@type} is a collection"
      title = "My #{@sub_title}#{@active}"
      num = parseInt params?.num ? 1
      per = config[@type]?.items_per_index ? 10
      paginator = collection.paginator per, num, @tagfilterer
      @adjustTitle title
      tags = _(_.flatten(collection.prefilter(@filterer).pluck 'tags')).uniq()
      tags = _.filter tags, (tag) -> tag

      @view = new IndexView
        collection: paginator.collection
        pages: paginator.pages
        filterer: @tagfilterer
        first_page: paginator.first_page
        last_page: paginator.last_page
        only_page: paginator.only_page
        cur_page: num
        next_page: num + 1
        prev_page: num - 1
        active: @active
        title: title
        recent: @recent
        popular: @popular
        random: @random
        tags: tags
        tag: @tag
        type: @type
        sub_type: @sub_type
        template: 'index'
        list_selector: '#excerpt-list'
        item_template: "#{@sub_type}-excerpt"
        item_class: config[@type].index_class

  archives: (params) =>
    utils.log "archives #{@type} site-controller"
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

    @view = new IndexView
      collection: collection
      active: active
      title: title
      recent: @recent
      type: @type
      sub_type: @sub_type
      template: 'archives'
      list_selector: '#archives-list'
      item_template: "#{@type}-archive-entry"
      item_class: config[@type].archive_class
      item_tag: config[@type].archive_tag
