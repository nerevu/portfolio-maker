View = require 'views/navbar-view'

class ViewTest extends View
  renderTimes: 0

  render: ->
    super
    @renderTimes += 1

describe 'View', ->
  beforeEach ->
    @view = new ViewTest

  afterEach ->
    @view.dispose()

  it 'should display 4 links', ->
    expect(@view.$el.find 'a').to.have.length 4
