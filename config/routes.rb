Rails.application.routes.draw do
  resources :urls, only: %i[create show], param: :slug do
    get '/stats', to: 'urls#stats'
  end
end
