Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # get 'analysis', to: 'morphemes#analysis'
  root 'morphemes#analysis'
  post '/', to: 'morphemes#post_goo'
end
