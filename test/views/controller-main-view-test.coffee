Controller = require 'controllers/site-controller'
mediator = require 'mediator'
config = require 'config'
portfolio = mediator.portfolio

describe 'ControllerMainView', =>
  type = portfolio.type
  filterer = config[type]?.filterer

  before =>
    @controller = new Controller {type}
    @composition = @controller.index()
    @view = @composition.compose()

  after =>
    @view.dispose()
    @composition.dispose()
    @controller.dispose()

  it 'should have 12 models', => @view.collection.should.have.length 12

  _(portfolio.models[...10]).each (model) =>
    id = model.get 'name'
    title = model.get 'title'
    find_where = {}
    find_where[config[type].identifier] = id

    do (model, find_where, title) => describe "Project #{title}", =>
      if model.get(filterer.key) is filterer.value
        it "should be in collection", =>
          @view.collection.findWhere(find_where).should.exist
      else
        it "expect to not be in collection", =>
          expect(@view.collection.findWhere(find_where)).to.be.undefined