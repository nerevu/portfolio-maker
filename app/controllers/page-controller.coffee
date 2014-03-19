Controller = require 'controllers/base/controller'
Page = require 'models/page'
PageView = require 'views/page-view'
utils = require 'lib/utils'

module.exports = class CodeController extends Controller
  pages: (params) =>
		page = params.page
    @model = new Pages(page)
		title = @model.get 'title'
    @adjustTitle "#{title}"
    console.log 'page controller'
    @view = new PageView {@model}
