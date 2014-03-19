mediator = module.exports = Chaplin.mediator

mediator.setActive = (title) ->
  mediator.active = title
  console.log "set activeNav: #{mediator.active}"
  mediator.publish 'activeNav'
