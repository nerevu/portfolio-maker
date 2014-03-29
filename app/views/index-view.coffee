CollectionView = require 'views/base/collection-view'
template = require 'views/templates/index'
View = require 'views/excerpt-view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class IndexView extends CollectionView
  itemView: View
  autoRender: true
  listSelector: '#excerpt-list'
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) ->
    super
    utils.log 'initializing index view'
    @type = options.type
    @sub_type = options.sub_type
    @recent = options.recent
    @popular = options.popular
    @pages = options.pages
    @first_page = options.first_page
    @last_page = options.last_page
    @cur_page = options.cur_page
    @next_page = options.next_page
    @prev_page = options.prev_page
    @title = options.title
    @className = options.class ? 'row'
    mediator.setActive options.active

  initItemView: (model) ->
    new @itemView
      model: model
      className: @className

  render: =>
    super
    utils.log 'rendering index view'

  getTemplateData: =>
    utils.log 'get index view template data'
    templateData = super
    templateData.sidebar = config[@type].index_sidebar
    templateData.collapsed = config[@type].index_collapsed
    templateData.asides = config[@type].index_asides
    templateData["recent_#{@sub_type}"] = @recent
    templateData["popular_#{@sub_type}"] = @popular
    templateData.page_title = @title
    templateData.pages = @pages
    templateData.first_page = @first_page
    templateData.last_page = @last_page
    templateData.cur_page = @cur_page
    templateData.next_page = @next_page
    templateData.prev_page = @prev_page
    templateData.type = @type
    templateData
