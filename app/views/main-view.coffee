CollectionView = require 'views/base/collection-view'
View = require 'views/item-view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class MainView extends CollectionView
  itemView: View
  autoRender: true
  className: 'row'
  region: 'content'

  initialize: (options) =>
    super
    utils.log 'initializing main view'
    @paginator = options.paginator
    @template_name = options.template
    @template = require "views/templates/#{@template_name}"
    @listSelector = options.list_selector
    @type = options.type
    @sub_type = options.sub_type
    @filterer = options.filterer
    @tagfilter = options.tagfilter
    @recent = options.recent
    @popular = options.popular
    @random = options.random
    @cur_page = options.cur_page
    @next_page = options.next_page
    @prev_page = options.prev_page
    @title = options.title
    @tags = options.tags
    @tag = options.tag
    mediator.setActive options.active

    @listenTo @, 'all', (event) =>
      utils.log "main-view heard #{event}", 'debug'

    @subscribeEvent "change:tags", (tags) =>
      utils.log 'main-view heard change:tags event'
      @tags = _(@tags).union tags
      @tags.sort()
      @getTemplateData()
      @render()

    @subscribeEvent 'screenshots:synced', (screenshots) =>
      utils.log 'main-view heard screenshots synced event'
      portfolio = mediator.portfolio
      portfolio.mergePortfolio screenshots
      @setTemplateData portfolio

    @subscribeEvent "#{@type}:synced", (collection) =>
      utils.log "main-view heard #{@type} synced event"
      @setTemplateData collection

  initItemView: (model) =>
    template_name = config[@type]["#{@template_name}_template"]
    new @itemView
      model: model
      template: require "views/templates/#{template_name}"
      className: config[@type]["#{@template_name}_class"]
      tagName: config[@type]?["#{@template_name}_tag"] ? 'div'

  render: ->
    super
    utils.log 'rendering main view'
    utils.log @collection, 'debug'

  setTemplateData: (collection) =>
    utils.log "main-view #{collection.type} template data"
    @paginator = collection.paginator @cur_page, @filterer
    @collection = @paginator.collection
    @recent = collection.recent
    @popular = collection.popular
    @random = collection.random
    @tags = collection.getTags @tagfilter
    @getTemplateData()
    @render()

  getTemplateData: =>
    utils.log 'get main view template data'
    templateData = super
    templateData.sidebar = config[@type]["#{@template_name}_sidebar"]
    templateData.collapsed = config[@type]["#{@template_name}_collapsed"]
    templateData.asides = config[@type]["#{@template_name}_asides"]
    templateData["recent_#{@sub_type}s"] = @recent
    templateData["popular_#{@sub_type}s"] = @popular
    templateData["random_#{@sub_type}s"] = @random
    templateData.page_title = @title
    templateData.pages = @paginator.pages
    templateData.first_page = @paginator.first_page
    templateData.last_page = @paginator.last_page
    templateData.only_page = @paginator.only_page
    templateData.cur_page = @cur_page
    templateData.next_page = @next_page
    templateData.prev_page = @prev_page
    templateData.type = @type
    templateData.sub_type = @sub_type
    templateData.tags = @tags
    templateData.tag = @tag
    templateData
