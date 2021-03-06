Model = require 'models/file'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Post extends Model
  # load md file as a model
  initialize: (attrs, options) =>
    super
    name = @get 'name'
    type = options.type
    sub_type = config[type]?.sub_type
    # utils.log "initializing #{name} #{sub_type} model"
    slug = name.split('-')[3..].join('-')
    date_arr = _.str.words(name, '-')[0..2]
    year = date_arr[0]
    month = date_arr[1]
    day = date_arr[2]
    date = moment new Date year, month - 1, day
    content = _.str.stripTags @get 'content'

    @set first: false
    @set last: false
    @set type: type
    @set sub_type: sub_type
    @set slug: slug
    @set year: year
    @set year_month: "#{year}#{month}"
    @set month: date.format("MMMM")
    @set day: _.str.ltrim(day, '0')
    @set date: date
    @set date_str: date.format("MMMM Do, YYYY")
    @set excerpt: _.str.prune content, 500
    @set href: "/#blog/#{year}/#{month}/#{day}/#{slug}"
    @set template: @get('template') ? 'item'
    @set partial: @get('partial') ? sub_type
    @set comments: @get('comments') ? true
    @set asides: @get('asides') ? config[type].page_asides
    @set sidebar: @get('sidebar') ? config[type].page_sidebar
    @set collapsed: @get('collapsed') ? config[type].page_collapsed
    @set tags: @get('tags') ? []

