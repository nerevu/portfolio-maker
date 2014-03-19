module.exports = (match) ->
  console.log 'start router'
  match '', 'home#show'
  match 'home', 'home#show'
  match 'projects', 'project#show'
  match ':page', 'page#show'
