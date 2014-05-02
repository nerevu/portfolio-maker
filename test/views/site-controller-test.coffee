SiteController = require 'controllers/site-controller'
mediator = require 'mediator'
config = require 'config'
portfolio = mediator.portfolio

describe 'SiteController', =>
  @controller = null

  _(portfolio.models).each (model) ->
    type = model.get 'type'
    filterer = config[type]?.filterer

    if model.get(filterer.key) is filterer.value
      do (model, type) -> describe "Project #{model.get 'title'}", ->
        id = model.get 'name'

        beforeEach => @controller = new SiteController({type, id})
        afterEach => @controller.dispose()

        it "model should be in collection", =>
          # @controller.show()
          # findWhere = @controller.paginator.collection.findWhere()
          find_where = @controller.find_where
          found = @controller.collection.findWhere(find_where) ? ''
          found.should.not.equal ''
