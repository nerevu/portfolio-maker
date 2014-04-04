Model = require 'models/base/model'
config = require 'config'
utils = require 'lib/utils'

module.exports = class Project extends Model
  github_api = "https://api.github.com/repos"
  token = "access_token=#{config.github.api_token}"
  url: => "#{github_api}/#{@get 'full_name'}?#{token}"

  sync: (method, model, options) =>
    model.local = -> method isnt 'read'
    # utils.log "#{model.get 'name'}'s method is #{method}"
    # utils.log "#{model.get 'name'}'s local is #{model.local()}"
    Backbone.sync(method, model, options)

  initialize: (attrs, options) =>
    super
    name = @get 'name'
    type = options?.collection_type
    sub_type = 'project'
    utils.log "initialize #{name} #{sub_type} model"
    # console.log @
    language = @get('language')?.toLowerCase()
    created = moment @get 'created_at'
    updated = moment @get 'updated_at'
    popularity = parseInt(@get 'stargazers_count') + parseInt(@get 'forks') * 2
    meta_base_url = "#{github_api}/#{@get 'full_name'}/contents"

    @set first: false
    @set last: false
    @set sub_type: sub_type
    @set type: type
    @set meta_base_url: meta_base_url
    @set title: name
    @set popularity: popularity
    @set href: "/portfolio/item/#{name}"
    @set template: 'item'
    @set partial: sub_type
    @set asides: config[type]?.page_asides
    @set sidebar: config[type]?.page_sidebar
    @set collapsed: config[type]?.page_collapsed
    @set created: created
    @set updated: updated
    @set created_str: created.format("MMMM Do, YYYY")
    @set updated_str: updated.format("MMMM Do, YYYY")

    @addTags language
    @meta_files = @getOptions language, 'meta_files'
    @package_managers = @getOptions language, 'package_managers'
    @getMeta()
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
    @set tags: (_.str.slugify(tag) for tag in tags)
    @save patch: true

  getMeta: =>
    promise = $.get "#{@get('meta_base_url')}?#{token}"
    do (model = @) ->
      promise.then(model.getFileList).then(model.fetchFiles)
      promise.fail(model.failWhale)

  getFileList: (data) =>
    names = _(data).pluck('name')
    _(names).intersection(@meta_files)

  fetchFiles: (files) =>
    for file in files
      promise = $.get "#{@get 'meta_base_url'}/#{file}?#{token}"
      do (model = @) ->
        promise.then(model.parseMeta).then(model.setMeta)
        promise.fail(model.failWhale)

  standardizeLicense: (license) =>
    if license? and license
      licenses = ['MIT', 'BSD', 'AGPL', 'LGPL', 'GPL', 'Apache', 'MPL']

      _(licenses).some (lic) ->
        match = _.str.count(license.toUpperCase(), lic)
        license = lic if match
        match

    license

  parseMeta: (data) =>
    meta = {}
    temp = {}
    content = Base64.decode data.content

    switch data.name
      when 'package.json'
        parsed = JSON.parse content
        meta.environment = parsed?.environment
        meta.version = parsed?.version
        meta.status = parsed?.status
        meta.license = parsed?.license

      when 'bower.json'
        parsed = JSON.parse content
        meta.environment = parsed?.environment
        meta.version = parsed?.version
        meta.license = parsed?.license
        meta.tags = parsed?.keywords

      when 'setup.py'
        parsed = _.str.lines content
        parsed = (_.str.clean(line) for line in parsed)
        parsed = _(parsed).filter (line) -> _.str.count line, '::'
        parsed = (_.str.ltrim(line, '\'') for line in parsed)
        parsed = (_.str.rtrim(line, ',\'') for line in parsed)

        for line in parsed
          words = _.str.words line, '::'
          key = _.first(words).trim().replace ' ', '_'
          values = (_.str.clean(word) for word in _.rest(words))
          long = values.length > 1
          temp[key] = if long then values else values.toString()

        meta.audience = temp?.Intended_Audience
        meta.environment = temp?.Environment
        meta.os = temp?.Operating_System
        meta.license = _.first _.rest (temp?.License ? [])
        meta.tags = temp?.Topic

      when 'package.xml'
        meta = $.parseXML content

      when 'pearfarm.spec'
        parsed = _.str.lines content
        parsed = (_.str.clean(line) for line in parsed)
        parsed = _(parsed).filter (line) -> _.str.startsWith line, '->'
        parsed = (_.str.ltrim(line, '->') for line in parsed)
        parsed = (_.str.rtrim(line, ')') for line in parsed)
        parsed = (line.replace('array(', '') for line in parsed)
        parsed = (line.replace('(', ',') for line in parsed)

        for line in parsed
          words = _.str.words line, ','
          values = (_.str.clean(word) for word in _.rest(words))
          values = (_.str.trim(word, '\'') for word in values)
          long = values.length > 1
          temp[_.first words] = if long then values else values.toString()

        cli = "Console_CommandLine" in (temp?.addPackageDependency ? [])
        license = _.str.words(temp?.setLicense, '::') ? []
        license = _.first(_.rest(license))
        meta.environment = if cli then 'console' else null
        meta.version = temp?.setReleaseVersion
        meta.license = license

    meta.license = @standardizeLicense meta.license
    meta

    # console.log @get 'name'
    # console.log data.name
    # console.log parsed
    # console.log temp
    # console.log meta
    # if @package_managers
    #   meta.package_manager = @package_managers[0]

  setMeta: (meta) =>
    tags = meta?.tags ? []
    for key, value of meta
      @set(key, value) if key isnt 'tags'
      tags.push value if not key in ['tags', 'version']

    @addTags tags
    @save patch: true

  failWhale: (res, textStatus, err) =>
    utils.log "failed to fetch #{@get 'name'}'s data"
    utils.log "error: #{err}", 'error' if err
