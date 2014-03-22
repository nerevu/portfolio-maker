module.exports = (match) ->
  console.log 'start router'
  match '', 'page#show'
  match 'projects', 'project#show'
  match ':year/:month/:day/:slug', 'post#show'
  match ':page', 'page#show'
