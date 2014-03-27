utils = require 'lib/utils'

module.exports = class Model extends Chaplin.Model
  # Mixin a synchronization state machine.
  # _(@prototype).extend Chaplin.SyncMachine
  # initialize: ->
  #   super
  #   @on 'request', @beginSync
  #   @on 'sync', @finishSync
  #   @on 'error', @unsync

  # DualStorage Fetch promise helper
  # --------------------------------
  modelFetch: =>
    utils.log 'fetching model...'
    $.Deferred((deferred) => @fetch
      success: deferred.resolve
      error: deferred.reject).promise()

