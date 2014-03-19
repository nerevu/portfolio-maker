View = require 'views/base/view'
template = require 'views/templates/home'
mediator = require 'mediator'
config = require 'config'

module.exports = class HomeView extends View
  autoRender: true
  className: 'row'
  region: 'content'
  template: template

  initialize: (options) =>
    super
    console.log 'initializing home view'
    mediator.setActive mediator.title

  render: =>
    super
    console.log 'rendering home view'
