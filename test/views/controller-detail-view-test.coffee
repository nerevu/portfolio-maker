Controller = require 'controllers/site-controller'
mediator = require 'mediator'
portfolio = mediator.portfolio

describe 'ControllerDetailView', =>
  type = portfolio.type

  _(portfolio.models[...5]).each (model) ->
    id = model.get 'name'
    title = model.get 'title'

    do (model, id, title) -> describe "Project #{title}", ->
      before =>
        @controller = new Controller {type, id}
        @composition = @controller.show()
        @view = @composition.compose()

      after =>
        @view.dispose()
        @composition.dispose()
        @controller.dispose()

      it "should have type: #{type}", =>
        @view.type.should.equal type

      it "should have title: #{title}", =>
        @view.title.should.equal title

      it 'should have at least 6 related', =>
        @view.related.should.have.length.of.at.least 6

      it 'should have 6 recent', =>
        @view.recent().should.have.length 6

      it 'should have 6 popular', =>
        @view.popular().should.have.length 6