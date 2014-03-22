Model = require 'models/file'

module.exports = class Post extends Model
  # load md file as a model
  initialize: (file) ->
    super
    console.log "initialize post model"
    name = @get 'name'
    date = moment _.str.words(name, '-')[0..2]
    slug = name.split('-')[3..].join('-')
    @set slug: slug
    @set href: "/#{@get 'slug'}"
    @set template: if @has('template') then @get('template') else 'post'
    @set date: if @has('date') then @get('date') else date
    @set comments: if @has('comments') then @get('comments') else true
    @set tags: if @has('tags') then @get('tags') else []
