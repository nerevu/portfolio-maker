Model = require 'models/base/model'

module.exports = class Project extends Model
  initialize: (options) ->
    super
    console.log "initialize project model"
    if @get('id')?
      files = @get 'files'
      sum = _.pluck(files, 'size').reduce (t, s) -> t + s
      @set size_files: Math.round(sum / 102.4) / 10
      @set num_files: (k for k of files).length


# * Language: php
# * Environment: console
# * License: [GPLv3](http://opensource.org/licenses/gplv3-license.php)
# * Status: beta
# * Availability: [pear](reubano.github.com/pear)
# Description
# 
# ## [View my other projects on GitHub](http://github.com/reubano)