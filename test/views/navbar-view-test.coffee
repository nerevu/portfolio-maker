NavbarView = require 'views/navbar-view'
mediator = require 'mediator'

describe 'NavbarView', ->
  beforeEach => @view = new NavbarView {collection: mediator.pages}
  afterEach => @view.dispose()

  it 'expect 3 models', => expect(@view.collection).to.have.length 3
  it 'should have 3 models', => @view.collection.should.have.length 3
  it 'should have 6 links', => @view.links.should.have.length 6

  it 'should have 6 nav items', =>
    @view.$el.find('ul.nav').children().should.have.length 6
