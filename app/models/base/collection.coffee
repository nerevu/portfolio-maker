Model = require './model'
config = require 'config'

module.exports = class Collection extends Chaplin.Collection
  # Mixin a synchronization state machine.
  # _(@prototype).extend Chaplin.SyncMachine
  # initialize: ->
  #   super
  #   @on 'request', @beginSync
  #   @on 'sync', @finishSync
  #   @on 'error', @unsync

  # Use the project base model per default, not Chaplin.Model
  model: Model

  getRecent: (type, filter=false) =>
    @sort()
    collection = if filter then @where(filter) else @
    collection = collection.slice 0, config[type].recent_count
    recent = []

    _.each collection, (model) ->
      href = model.get 'href'
      title = model.get 'title'
      recent.push({href: href, title: title})

    recent
