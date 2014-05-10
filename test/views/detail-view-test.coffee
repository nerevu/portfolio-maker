DetailView = require 'views/detail-view'
mediator = require 'mediator'
config = require 'config'
portfolio = mediator.portfolio
recent = portfolio.recent
popular = portfolio.popular
random = portfolio.random

describe 'DetailView', ->
  type = portfolio.type
  active = _.str.capitalize type
  pager = config[type].show_pager

  _(portfolio.models[...5]).each (model) ->
    title = model.get 'title'

    do (model, title) -> describe "Project #{title}", ->
      sub_type = model.get 'sub_type'
      id = model.get 'name'
      related = portfolio.getRelated model

      opts = {model, title, id, type, sub_type, active, pager, recent, popular}
      _(opts).extend {random, related}
      before => @view = new DetailView opts
      after => @view.dispose()

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