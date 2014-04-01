# TODO: google analytics
# TODO: 'http://fonts.googleapis.com/css
# ?family=Ubuntu:400,400italic,700,700italic'
# TODO: (<meta name=key content=value> for key, value in meta)
# TODO: rss
# TODO: tags and tag cloud
# TODO: move disqus script to bower

config =
  ################
  # Main Configs #
  ################
  author: 'Reuben Cummings'
  email: 'reubano@gmail.com'
  site: 'reubano.github.io'

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
    {href: '/portfolio', title: 'Portfolio'}
    {href: '/gallery', title: 'Gallery'}
    {href: '/blog', title: 'Blog'}
    {href: '/blog/archives', title: 'Archives'}
  ]

  ###########
  # Plugins #
  ###########
  search_bar: true

  pages:
    # asides: ['popular-projects', 'popular-photos', 'popular-posts']
    asides: ['popular-projects', 'popular-photos', 'recent-posts']

  portfolio:
    index: true
    archives: true
    page_sidebar: true
    index_sidebar: true
    archives_sidebar: true
    page_collapsed: false
    index_collapsed: false
    archives_collapsed: false
    page_asides: ['related-projects', 'recent-projects', 'popular-projects']
    index_asides: ['recent-projects', 'popular-projects', 'random-projects']
    archives_asides: []
    recent_count: 6
    popular_count: 6
    related_count: 6
    random_count: 6
    items_per_index: 10
    show_pager: true
    filterer: {fork: false}
    identifier: 'name'
    recent_comparator: 'created_at'
    popular_comparator: 'popularity'

  gallery:
    index: true
    archives: true
    page_sidebar: true
    index_sidebar: true
    archives_sidebar: true
    page_collapsed: false
    index_collapsed: true
    archives_collapsed: false
    page_asides: ['related-photos', 'recent-photos', 'popular-photos']
    index_asides: ['recent-photos', 'popular-photos', 'random-photos']
    archives_asides: []
    recent_count: 5
    popular_count: 12
    related_count: 5
    random_count: 5
    items_per_index: 12
    index_class: 'col-sm-6 col-md-4'
    show_pager: true
    identifier: 'id'
    recent_comparator: 'created'
    popular_comparator: 'views'

  blog:
    index: true
    archives: true
    page_sidebar: true
    index_sidebar: true
    archives_sidebar: false
    page_collapsed: false
    index_collapsed: false
    archives_collapsed: false
    page_asides: ['related-posts', 'recent-posts', 'popular-posts']
    index_asides: ['recent-posts', 'popular-posts', 'random-posts']
    archives_asides: []
    recent_count: 5
    popular_count: 5
    related_count: 5
    random_count: 5
    items_per_index: 10
    show_pager: true
    identifier: 'slug'
    recent_comparator: 'date'
    popular_comparator: 'comments'

  ######################
  # 3rd Party Settings #
  ######################
  github:
    user: 'reubano'
    api_token: 'cdac348c97dbdf5252d530103e0bfb2b9275d126'
    skip_forks: true
    show_follow_badge: true
    show_follower_count: false

  flickr:
    user: 'reubano'
    api_token: '76ca8dd185de46fdd0d24c24f6e4d0ea'
    secret: '7e8d94900e2a23c0'
    collection_id: '72157642990278515'
    show_follow_badge: true
    show_follower_count: false

  twitter:
    user: 'reubano'
    api_token: 'cdac348c97dbdf5252d530103e0bfb2b9275d126'
    show_follow_badge: true
    show_follower_count: false
    show_replies: false

  google:
    analytics_tracking_id: 'UA-35222393-1'

  disqus:
    user: 'reubano'
    show_comment_count: true

  # Geolookup
  srch_providers:
    google: L.GeoSearch.Provider.Google
    osm: L.GeoSearch.Provider.OpenStreetMap
    esri: L.GeoSearch.Provider.Esri

  # Maps
  tile_providers:
    mapbox: {name: 'MapBox.reubano.ghdp3e73', key: null}
    osm: {name: 'OpenStreetMap', key: null}
    esri: {name: 'Esri.WorldTopoMap', key: null}
    cloudmade: {name: 'CloudMade', key: '82e495a4e43045118b51a94617d211c0'}

  mapping:
    icon: 'home'
    markerColor: 'green'
    markers: false
    tile_provider: 'esri'
    tp_options: {maxZoom: 5, styleID: 1}
    srch_provider: 'openstreetmap'
    zoomLevel: 3
    setView: true

module.exports = config
