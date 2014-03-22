Model = require 'models/file'
config = require 'config'

module.exports = class Post extends Model
  # load md file as a model
  initialize: (file) ->
    super
    console.log "initialize post model"
    name = @get 'name'
    slug = name.split('-')[3..].join('-')
    date_arr = _.str.words(name, '-')[0..2]
    year = date_arr[0]
    month = date_arr[1]
    day = date_arr[2]
    date = new Date year, month - 1, day
    content = _.str.stripTags @get 'content'

    @set slug: slug
    @set date: date
    @set date_str: date.toDateString()
    @set excerpt: _.str.prune content, 500
    @set href: "/blog/#{year}/#{month}/#{day}/#{slug}"
    @set template: if @has('template') then @get('template') else 'post'
    @set comments: if @has('comments') then @get('comments') else true
    @set asides: if @has('asides') then @get('asides') else config.post_asides
    @set tags: if @has('tags') then @get('tags') else []
