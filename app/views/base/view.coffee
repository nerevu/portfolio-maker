config = require 'config'
mediator = require 'mediator'
require 'lib/view-helper' # Just load the view helpers, no return value

module.exports = class View extends Chaplin.View
  # Auto-save `template` option passed to any view as `@template`.
  optionNames: Chaplin.View::optionNames.concat ['template']
  listen:
    # 'all': (event) => console.log "base-view heard #{event}"
    'change model': => console.log "base-view heard model change"

  # Precompiled templates function initializer.
  getTemplateFunction: -> @template
