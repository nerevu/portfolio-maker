Model = require 'models/base/model'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Project extends Model
  github_api = "https://api.github.com/repos"
  token = "access_token=#{config.github.api_token}"
  url: => "#{github_api}/#{@get 'full_name'}?#{token}"

  sync: (method, model, options) =>
    # if model?.collection?
    model.local = -> method isnt 'read'
    # utils.log "#{model.get 'name'}'s method is #{method}"
    # utils.log "#{model.get 'name'}'s local is #{model.local()}"
    # https://github.com/nilbus/Backbone.dualStorage/issues/78
    # options.add = method is 'read'
    # utils.log options
    Backbone.sync(method, model, options)

  initialize: (options) ->
    super
    name = @get 'name'
    utils.log "initialize #{name} project model"
    language = @get('language')?.toLowerCase()
    type = 'project'
    created = moment @get 'created_at'
    updated = moment @get 'updated_at'

    @set type: type
    @set title: name
    @set href: "/portfolio/#{name}"
    @set template: 'item'
    @set partial: type
    @set asides: config.portfolio.page_asides
    @set sidebar: config.portfolio.page_sidebar
    @set collapsed: config.portfolio.page_collapsed
    @set created: created
    @set updated: updated
    @set created_str: created.format("MMMM Do, YYYY")
    @set updated_str: updated.format("MMMM Do, YYYY")

    if language then @addTags [language]
    @meta_files = @getOptions language, 'meta_files'
    @package_managers = @getOptions language, 'package_managers'
    # @meta_files.push 'meta.yml'

  getOptions: (language, option) =>
    switch language
      when 'javascript', 'coffeescript'
        switch option
          when 'meta_files' then ['bower.json', 'package.json']
          when 'package_managers' then ['npm', 'bower']
      when 'python'
        switch option
          when 'meta_files' then ['setup.py']
          when 'package_managers' then ['pypi']
      when 'php'
        switch option
          when 'meta_files' then ['package.xml', 'pearfarm.spec']
          when 'package_managers' then ['pear']
      when 'shell'
        switch option
          when 'meta_files' then ['portfile']
          when 'package_managers' then ['macports']
      else []

  addTags: (newTags) =>
    curTags = @get 'tags'
    tags = _.filter _.union(curTags, newTags), (tag) -> tag
    @set tags: tags
    @save patch: true
