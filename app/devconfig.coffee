debug_mobile = false
debug_production = false
verbose = true

host = window?.location?.hostname ? require('os').hostname()
ua = navigator?.userAgent?.toLowerCase()
list = 'iphone|ipod|ipad|android|blackberry|opera mini|opera mobi'
mobile_device = (/"#{list}"/).test ua

if mocha? or mochaPhantomJS?
  environment = 'testing'
  storage_mode = 'file'
  api_logs = ''
else if host in ['localhost', 'tokpro.local', 'tokpro'] and not debug_production
  environment = 'development'
  storage_mode = 'dualsync'
  api_logs = "http://localhost:8888/api/logs"
  stale_age = 72 # in hours
else
  environment = 'production'
  storage_mode = 'file'
  api_logs = 'http://flogger.herokuapp.com/api/logs'
  stale_age = 12 # in hours

mobile = debug_mobile or mobile_device
console.log "host: #{host}"
console.log "#{environment} environment set"
console.log "mobile device: #{mobile}"
console.log "debug production: #{debug_production}"
console.log "storage mode: #{storage_mode}"

devconfig =
  ########################
  # Development Settings #
  ########################
  file_storage: storage_mode is 'file'
  dual_storage: storage_mode is 'dualsync'
  prod: environment is 'production'
  dev: environment is 'development'
  testing: environment is 'testing'
  verbose: verbose
  api_logs: api_logs
  mobile: mobile
  stale_age: stale_age

module.exports = devconfig
