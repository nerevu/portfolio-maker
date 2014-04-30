NavbarView = require 'views/navbar-view'
mediator = require 'mediator'

describe 'NavbarView', =>
  beforeEach => @view = new NavbarView {collection: mediator.pages}
  afterEach => @view.dispose()

  it 'expect 3 links', => expect(@view.collection).to.have.length 3
