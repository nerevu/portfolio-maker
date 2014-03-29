mediator = require 'mediator'

# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# Partials
# ----------------------
register 'partial', (name, context) ->
  template = require "views/templates/partials/#{name}"
  new Handlebars.SafeString template context

# Helpers
# -----------
# Make 'with' behave a little more mustachey.
register 'with', (context, options) ->
  if not context or Handlebars.Utils.isEmpty context
    options.inverse(this)
  else
    options.fn(context)

# Inverse for 'with'.
register 'without', (context, options) ->
  inverse = options.inverse
  options.inverse = options.fn
  options.fn = inverse
  Handlebars.helpers.with.call(this, context, options)

# Get Chaplin-declared named routes. {{url "likes#show" "105"}}
register 'url', (routeName, params..., options) ->
  Chaplin.helpers.reverse routeName, params

# Conditional evaluation
# ----------------------
register 'ifLoggedIn', (options) ->
  if mediator.user then options.fn(this) else options.inverse(this)

register 'ifActive', (title, options) ->
  if mediator.active is title then options.fn(this) else options.inverse(this)

register 'ifCurrent', (page, cur_page, options) ->
  if page is cur_page then options.fn(this) else options.inverse(this)

# Other helpers
# -----------
# Convert date to day
register 'getDay', (date) ->
  day = if date[-2..-2] is '0' then date[-1..] else date[-2..]
  new Handlebars.SafeString day

# Loop n times
register 'times', (n, block) ->
  accum = ''
  i = 1
  x = n + 1

  while i < x
    accum += block.fn(i)
    i++

  accum
