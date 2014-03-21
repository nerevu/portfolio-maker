# TODO: google analytics
# TODO: 'http://fonts.googleapis.com/css
# ?family=Ubuntu:400,400italic,700,700italic'
# TODO: (<meta name=key content=value> for key, value in meta)
# TODO: rss
# TODO: tags and tag cloud
# TODO: move disqus script to bower

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

config =
  ################
  # Main Configs #
  ################
  author: 'Reuben Cummings'
  email: 'reubano@gmail.com'
  url: 'http://reubano.github.com'

  # The default title of this website
  title: "reubano"
  subtitle: 'Random thoughts on technology, finance, travel, and life'

  # The website description (for SEO)
  description: """
    My personal website covering finance, technology, mac osx, travel, and web
    application development
    """

  # The website keywords (for SEO) separated by commas
  keywords: """
    mac, osx, python, linux, investing, asset allocation, travel hacking,
    portfolio performance, risk, return, web application development,
    restful api, flask, node, javascript, coffeescript
    """

  # Pages other than the blog and markdown files you want menu items for
  generated_pages: [
    {href: '/projects', title: 'projects'}
  ]

  ###########
  # Plugins #
  ###########
  search_bar: true
  blog_archives: true
  blog_base_url: 'blog'
  # permalink: "/#{blog_base_url}/{year}/{month}/{day}/{title}/"
  paginate: 10          # Posts per page on the blog index
  recent_posts: 5       # Posts in the sidebar Recent Posts section
  titlecase: true       # Converts page and post titles to titlecase

  # list each of the sidebar modules you want to include, in the order you want
  # them to appear.
  # To add custom asides, create files in /source/_includes/custom/asides/ and
  # add them to the list like 'custom_aside_name'
  page_asides: 'popular_posts, github, twitter, googleplus'
  # blog_index_asides: 'recent_posts, popular_posts, twitter'
  post_asides: 'related_posts, recent_posts, popular_posts'

  ######################
  # 3rd Party Settings #
  ######################
  # Github
  github_user: 'reubano'
  github_repo_count: 3
  github_show_profile_link: true
  github_skip_forks: true

  # Twitter
  twitter_user: 'reubano'
  twitter_tweet_count: 3
  twitter_show_replies: false
  twitter_follow_button: true
  twitter_show_follower_count: false
  twitter_tweet_button: true

  # Google
  googleplus_user: 'reubano'
  googleplus_hidden: true  # No visible button
  google_plus_one: true
  google_plus_one_size: 'medium'
  google_analytics_tracking_id: 'UA-35222393-1'

  # Disqus Comments
  disqus_short_name: 'reubano'
  disqus_show_comment_count: true

  # Facebook
  facebook_like: true

  # Geolookup
  # srch_providers:
  #   google: L.GeoSearch.Provider.Google
  #   osm: L.GeoSearch.Provider.OpenStreetMap
  #   esri: L.GeoSearch.Provider.Esri

  # Mapping
  tile_providers:
    mapbox: {name: 'MapBox.reubano.ghdp3e73', key: null}
    osm: {name: 'OpenStreetMap', key: null}
    esri: {name: 'Esri.WorldTopoMap', key: null}
    cloudmade: {name: 'CloudMade', key: '82e495a4e43045118b51a94617d211c0'}

  options:
    icon: 'home'
    markerColor: 'green'
    markers: false
    tile_provider: 'esri'
    tp_options: {maxZoom: 5, styleID: 1}
    srch_provider: 'openstreetmap'
    zoomLevel: 3
    setView: true

  ########################
  # Development Settings #
  ########################
  github_api_token: 'cdac348c97dbdf5252d530103e0bfb2b9275d126'
  mode: mode
  prod: production_mode
  debug_prod: debug_production
  dev: dev_mode
  api_logs: api_logs
  mobile: mobile
  max_age: age

module.exports = config
