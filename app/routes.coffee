module.exports = (match) ->
  console.log 'start router'
  match '', 'page#show'
  match 'projects', 'project#show'
  match 'blog', 'post#index'
  match 'blog/:year/:month/:day/:slug', 'post#show'
  match 'archives', 'post#archives'
  match ':page', 'page#show'
