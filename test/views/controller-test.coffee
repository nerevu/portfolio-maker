Controller = require 'controllers/site-controller'
mediator = require 'mediator'
config = require 'config'
portfolio = mediator.portfolio

describe 'Controller', =>
  type = portfolio.type

  _(portfolio.models[...5]).each (model) ->
    id = model.get 'name'
    title = model.get 'title'

    do (model, type, title) -> describe "Project #{title}", ->
      before => @controller = new Controller {type, id}
      after => @controller.dispose()

      it "should be in collection", =>
        find_where = @controller.find_where
        @controller.collection.findWhere(find_where).should.exist
