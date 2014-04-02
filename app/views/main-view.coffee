CollectionView = require 'views/base/collection-view'
View = require 'views/base/view'
mediator = require 'mediator'
config = require 'config'
utils = require 'lib/utils'

module.exports = class IndexView extends CollectionView
  itemView: View
  autoRender: true
  className: 'row'
  region: 'content'

  initialize: (options) ->
    super
    utils.log 'initializing main view'
    @template_name = options.template
    @template = require "views/templates/#{@template_name}"
    @listSelector = options.list_selector
    @type = options.type
    @sub_type = options.sub_type
    @recent = options.recent
    @popular = options.popular
    @random = options.random
    @pages = options.pages
    @first_page = options.first_page
    @last_page = options.last_page
    @only_page = options.only_page
    @cur_page = options.cur_page
    @next_page = options.next_page
    @prev_page = options.prev_page
    @title = options.title
    @tags = options.tags
    @tag = options.tag
    @item_template = options.item_template
    @item_class = options?.item_class
    @item_tag = options?.item_tag
    mediator.setActive options.active

  initItemView: (model) =>
    new @itemView
      model: model
      className: @item_class
      tagName: @item_tag
      template: require "views/templates/#{@item_template}"
      # name: model.get 'name'
      # type: model.get 'type'
      # sub_type: model.get 'sub_type'

  render: =>
    super
    utils.log 'rendering main view'

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
    templateData.pages = @pages
    templateData.first_page = @first_page
    templateData.last_page = @last_page
    templateData.only_page = @only_page
    templateData.cur_page = @cur_page
    templateData.next_page = @next_page
    templateData.prev_page = @prev_page
    templateData.type = @type
    templateData.sub_type = @sub_type
    templateData.tags = @tags
    templateData.tag = @tag
    templateData
