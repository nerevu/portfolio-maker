require 'initialize'

# require tests
$ ->
  window.require.list()
    .filter((_) -> /-test$/.test(_))
    .forEach(require)
