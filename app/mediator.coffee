mediator = module.exports = Chaplin.mediator

mediator.setActive = (title) ->
  mediator.active = title
  mediator.publish 'activeNav'
