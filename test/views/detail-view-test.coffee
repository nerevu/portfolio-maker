DetailView = require 'views/detail-view'
mediator = require 'mediator'
config = require 'config'

# mediator.subscribe 'portfolio:synced', (portfolio) ->
portfolio = mediator.portfolio
recent = portfolio.recent
popular = portfolio.popular
random = portfolio.random

describe 'DetailView', ->
  _(portfolio.models[...5]).each (model) ->
    do (model) -> describe "Project #{model.get 'title'}", ->
      title = model.get 'title'
      type = model.get 'type'
      sub_type = model.get 'sub_type'
      id = model.get 'name'
      active = _.str.capitalize type
      pager = config[type].show_pager
      related = portfolio.getRelated model

      opts = {model, title, id, type, sub_type, active, pager, recent, popular}
      _(opts).extend {random, related}
      beforeEach => @view = new DetailView opts
      afterEach => @view.dispose()

      it "should have 'portfolio' type", =>
        @view.model.attributes.type.should.equal 'portfolio'

      it 'should have a title', =>
        @view.$('h1').text().should.not.equal 'Not Found'

      it 'should have at least 7 related', =>
        @view.$('div.gallery-related').children().should.have.length.of.at.least 6

      it 'should have 6 recent', =>
        @view.$('div.gallery-recent').children().should.have.length 6

      it 'should have 6 popular', =>
        @view.$('div.gallery-popular').children().should.have.length 6