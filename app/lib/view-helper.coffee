mediator = require 'mediator'

# Application-specific view helpers
# http://handlebarsjs.com/#helpers
# --------------------------------

register = (name, fn) ->
  Handlebars.registerHelper name, fn

# Map helpers
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

# Partials
# ----------------------
Handlebars.registerPartial

# Conditional evaluation
# ----------------------
Handlebars.registerHelper 'ifLoggedIn', (options) ->
  if mediator.user then options.fn(this) else options.inverse(this)

Handlebars.registerHelper 'ifActive', (title, options) ->
  if mediator.active is title then options.fn(this) else options.inverse(this)

# Other helpers
# -----------

# Convert date to day
Handlebars.registerHelper 'getDay', (date) ->
  day = if date[-2..-2] is '0' then date[-1..] else date[-2..]
  new Handlebars.SafeString day

# Loop n times
Handlebars.registerHelper 'times', (n, block) ->
  accum = ''
  i = 0
  x = Math.round n

  while i < x
    accum += block.fn(i)
    i++

  accum
