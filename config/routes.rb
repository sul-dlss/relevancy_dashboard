Rails.application.routes.draw do
  resources :endpoints
  resources :searches do
    get 'search_results/:search_result_id/explain/:id', to: 'searches#explain', as: :explain
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root to: 'searches#index'
end
