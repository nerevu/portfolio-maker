Model = require 'models/base/model'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Project extends Model
  language_options:
    javascript:
      meta_files: ['bower.json', 'package.json']
      package_managers: ['npm', 'bower']
    coffeescript:
      meta_files: ['bower.json', 'package.json']
    python:
      meta_files: ['setup.py']
      package_managers: ['pypi']
    php:
      meta_files: ['package.xml', 'pearfarm.spec']
      package_managers: ['pear']
    shell:
      meta_files: ['portfile']
      package_managers: ['macports']

  github_api: "https://api.github.com/repos"
  token: "access_token=#{config.github.api_token}"
  url: => "#{github_api}/#{@get 'full_name'}"

  sync: (method, model, options) =>
    @local = -> method isnt 'read'
    model.collection.local = @local
    # https://github.com/nilbus/Backbone.dualStorage/issues/78
    # options.add = method is 'read'
    # utils.log options
    utils.log "#{model.get 'name'}'s sync method is #{method}"
    utils.log "sync #{model.get 'name'} to server: #{not @local()}"
    Backbone.sync(method, model, options)

  initialize: (options) ->
    super
    name = @get 'name'
    utils.log "initialize #{name} project model"
    language = @get('language')?.toLowerCase()
    type = 'project'

    @set type: type
    @set title: name
    @set href: "/portfolio/#{name}"
    @set template: 'item'
    @set partial: type
    @set asides: config.portfolio.page_asides
    @set sidebar: config.portfolio.page_sidebar
    @set collapsed: config.portfolio.page_collapsed
    @addTags [language]
    @meta_files = @language_options[language]?.meta_files ? []
    @package_managers = @language_options[language]?.package_managers ? []
    # @meta_files.push 'meta.yml'

  addTags: (newTags) =>
    curTags = @get 'tags'
    tags = _.union curTags, newTags
    @set tags: tags
    @save patch: true
