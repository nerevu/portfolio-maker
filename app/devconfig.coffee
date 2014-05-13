debug_mobile = false
debug_production = false
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
  force_mobile = debug_mobile
  api_logs = "http://localhost:8888/api/logs"
  age = 72 # in hours
else
  environment = 'production'
  storage_mode = 'file'
  api_logs = 'http://flogger.herokuapp.com/api/logs'
  age = 12 # in hours

mobile = force_mobile ? mobile_device
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
  debug_prod: debug_production
  prod: environment is 'production'
  dev: environment is 'development'
  testing: environment is 'testing'
  api_logs: api_logs
  mobile: mobile
  max_age: age

module.exports = devconfig
