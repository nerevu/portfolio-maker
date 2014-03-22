module.exports = (match) ->
  console.log 'start router'
  match '', 'page#show'
  match 'projects', 'project#show'
  match 'blog', 'post#index'
  match ':page', 'page#show'
