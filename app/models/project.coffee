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
    sub_type = config[type]?.sub_type
    # utils.log "initialize #{name} #{sub_type} model"
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

    # @addTags [language]
    @meta_files = @getOptions language, 'meta_files'
    @package_managers = @getOptions language, 'package_managers'
    # @meta_files.push 'meta.yml'
    @getMeta() if not (@get('meta') or @get('fetching_meta'))

  getOptions: (language, option) =>
    switch language
      when 'javascript', 'coffeescript', 'css'
        switch option
          when 'meta_files' then ['package.json', 'bower.json']
          when 'package_managers' then ['npm', 'bower']
      when 'python'
        switch option
          when 'meta_files' then ['setup.py']
          when 'package_managers' then ['pypi']
      when 'php'
        switch option
          when 'meta_files' then [
            'composer.json', 'pearfarm.spec', 'package.xml']
          when 'package_managers' then ['pear']
      when 'shell'
        switch option
          when 'meta_files' then ['portfile']
          when 'package_managers' then ['macports']
      else []

  addTags: (newTags) =>
    if newTags
      curTags = @get 'tags'
      tags = (_.str.slugify(tag) for tag in newTags)
      combo = _(curTags).union(tags)
      filtered = _(combo).filter (tag) -> tag
      filtered.sort()
      @set tags: filtered
      @save patch: true

  getMeta: =>
    console.log "getMeta for #{@get 'name'}"
    @set fetching_meta: true
    promise = $.get "#{@get('meta_base_url')}?#{token}"

    do (model = @) -> promise
      .then(model.getFileList)
      .then(model.fetchFiles)
      .fail(model.failWhale)

  getFileList: (data) =>
    names = _(data).pluck('name')
    _(@meta_files).intersection(names)

  fetchFiles: (files) =>
    file = _.first(files)
    if file
      promise = $.get "#{@get 'meta_base_url'}/#{file}?#{token}"

      do (model = @) -> promise
        .then(model.parseMeta)
        .then(model.setMeta)
        .fail(model.failWhale)

  standardizeTags: (tags) =>
    if tags? and tags
      members = []
      tags = _.union tags

      for member in tags
        switch member
          when 'Investment' then members.push 'finance'
          else members.push member

      members

  standardizeAudience: (audience) =>
    if audience? and audience
      members = []
      audience = _.union audience

      for member in audience
        switch member
          when 'Financial and Insurance Industry' then members.push 'finance'
          when 'Science/Research' then members.push 'science'
          when 'End Users/Desktop' then members.push 'end-users'

      members

  standardizeEnvironment: (environment) =>
    if environment? and environment
      members = []
      environment = _.union environment

      for member in environment
        member = member.toLowerCase().replace 'environment', ''
        members.push _.str.clean member

      members

  standardizeLicense: (license) =>
    if license? and license
      ls = []
      license = _.union license
      licenses = ['MIT', 'BSD', 'AGPL', 'LGPL', 'GPL', 'Apache', 'MPL']

      for l in license
        _(licenses).some (lic) ->
          match = _.str.count(l.toUpperCase(), lic)
          ls.push(lic) if match
          match

      ls

  parseMeta: (data) =>
    meta = {}
    temp = {}
    content = Base64.decode data.content
    # console.log @get 'name'
    # console.log data.name

    switch data.name
      when 'package.json'
        parsed = JSON.parse content
        meta.environment = parsed?.environment
        meta.version = parsed?.version
        meta.status = parsed?.status
        meta.license = parsed?.license
        meta.tags = parsed?.keywords

      when 'bower.json'
        parsed = JSON.parse content
        meta.environment = parsed?.environment
        meta.version = parsed?.version
        meta.license = parsed?.license
        meta.tags = parsed?.keywords

      when 'composer.json'
        parsed = JSON.parse content
        meta.environment = parsed?.environment
        meta.type = parsed?.type ? 'library'
        meta.version = parsed?.version
        meta.license = parsed?.license
        meta.tags = parsed?.keywords

      when 'setup.py'
        parsed = _.str.lines content
        parsed = (_.str.clean(line) for line in parsed)
        parsed = (_.str.trim(line, "'") for line in parsed)
        parsed = (_.str.trim(line, '"') for line in parsed)
        keywords = _(parsed).filter (line) -> _.str.startsWith line, 'keywords'
        version = _(parsed).filter (line) -> _.str.startsWith line, 'version'
        parsed = _(parsed).filter (line) -> _.str.count line, '::'
        parsed = (_.str.trim(line, ',\'') for line in parsed)

        if keywords.length > 0
          keywords = _.first keywords
          splitby = if _.str.count(keywords, '=') then '=' else ':'
          keywords = keywords.split splitby
          keywords = _.last(keywords).trim()
          keywords = _.str.trim keywords, '('
          keywords = _.str.trim keywords, ')'
          keywords = _.str.trim keywords, ','
          keywords = _.str.trim keywords, "'"
        else
          keywords = ''

        if version.length > 0
          version = _.first version
          splitby = if _.str.count(version, '=') then '=' else ':'
          version = version.split splitby
          version = _.last(version).trim()
          version = _.str.trim version, ","
          version = _.str.trim version, "'"

        for line in parsed
          words = _.str.words line, '::'
          key = _.first(words).trim().replace ' ', '_'
          value = _.last(words).trim()
          if temp?[key]
            temp[key] = _(temp[key]).union value
          else
            temp[key] = value

        meta.audience = temp?.Intended_Audience
        meta.environment = temp?.Environment
        meta.os = temp?.Operating_System
        meta.license = temp?.License
        meta.tags = _.union keywords.split(','), temp?.Topic
        meta.version = version

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

    meta.tags = @standardizeTags meta.tags
    meta.audience = @standardizeAudience meta.audience
    meta.environment = @standardizeEnvironment meta.environment
    meta.license = @standardizeLicense meta.license
    meta

    # if @package_managers
    #   meta.package_manager = @package_managers[0]

  setMeta: (meta) =>
    tags = _.union meta?.tags, []
    for key, value of meta
      @set(key, value) if key isnt 'tags'
      tags = _(tags).union value if key not in [
        'tags', 'version', 'os', 'license', 'type']

    @addTags tags
    @set meta: true
    @set fetching_meta: false
    @save patch: true

  failWhale: (res, textStatus, err) =>
    utils.log "failed to fetch #{@get 'name'}'s data"
    utils.log "error: #{err}", 'error' if err
