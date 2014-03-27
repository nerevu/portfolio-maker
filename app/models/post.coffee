Model = require 'models/file'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Post extends Model
  # load md file as a model
  initialize: (file) ->
    super
    name = @get 'name'
    utils.log "initialize #{name} post model"
    type = 'post'
    slug = name.split('-')[3..].join('-')
    date_arr = _.str.words(name, '-')[0..2]
    year = date_arr[0]
    month = date_arr[1]
    day = date_arr[2]
    date = moment new Date year, month - 1, day
    content = _.str.stripTags @get 'content'

    @set type: type
    @set slug: slug
    @set year: year
    @set year_month: "#{year}#{month}"
    @set month: date.format("MMMM")
    @set day: _.str.ltrim(day, '0')
    @set date: date
    @set date_str: date.format("MMMM Do, YYYY")
    @set excerpt: _.str.prune content, 500
    @set href: "/blog/#{year}/#{month}/#{day}/#{slug}"
    @set template: @get('template') ? 'item'
    @set partial: @get('partial') ? type
    @set comments: @get('comments') ? true
    @set asides: @get('asides') ? config.blog.page_asides
    @set sidebar: @get('sidebar') ? config.pages.page_sidebar
    @set collapsed: @get('collapsed') ? config.pages.page_collapsed
    @set tags: @get('tags') ? []

