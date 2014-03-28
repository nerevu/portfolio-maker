module.exports = (match) ->
  console.log 'start router'
  match '', 'page#show'
  match 'portfolio', 'project#index'
  match 'portfolio/:repo', 'project#show'
  match 'gallery', 'photo#index'
  match 'gallery/page', 'photo#index'
  match 'gallery/page/:num', 'photo#index'
  match 'gallery/item', 'photo#show'
  match 'gallery/item/:id', 'photo#show'
  match 'blog', 'post#index'
  match 'blog/:year/:month/:day/:slug', 'post#show'
  match 'archives', 'post#archives'
  match ':page', 'page#show'
