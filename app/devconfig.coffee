debug_mobile = false
debug_production = false
host = window?.location?.hostname ? require('os').hostname()
dev_mode = host in ['localhost', 'tokpro.local', 'tokpro']
production_mode = not dev_mode
ua = navigator?.userAgent?.toLowerCase()
list = 'iphone|ipod|ipad|android|blackberry|opera mini|opera mobi'
mobile_device = (/"#{list}"/).test ua
force_mobile = (dev_mode and debug_mobile)
mobile = mobile_device or force_mobile

if dev_mode and not debug_production
  console.log 'development envrionment set'
  mode = 'development'
  api_logs = "http://localhost:8888/api/logs"
  age = 72 # in hours
else
  console.log 'production envrionment set'
  mode = 'production'
  api_logs = 'http://flogger.herokuapp.com/api/logs'
  age = 12 # in hours

console.log "host: #{host}"
console.log "mobile device: #{mobile}"
console.log "debug production: #{debug_production}"

devconfig =
  ########################
  # Development Settings #
  ########################
  mode: mode
  prod: production_mode
  debug_prod: debug_production
  dev: dev_mode
  api_logs: api_logs
  mobile: mobile
  max_age: age

module.exports = devconfig
