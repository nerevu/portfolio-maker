View = require 'views/main-view'

describe 'View', ->
  beforeEach ->
    @view = new View

  afterEach ->
    @view.dispose()

  it 'should auto-render', ->
    expect(@view.$el.find 'img').to.have.length 1
