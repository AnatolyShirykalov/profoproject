Rails.application.routes.draw do

  resources :albums, only: %i[index show]

  get 'partiables', to: 'partiable#index'
  get 'partiable/:stage', to: 'partiable#show', as: :partiable

  get 'stage/:slug', to: 'stages#show', as: :stage
  resources :marks, only: [:create]
  resources :photos, only: %i[new create]
  devise_for :users, controllers: {
      omniauth_callbacks: 'users/omniauth_callbacks',
  }
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount Ckeditor::Engine => '/ckeditor'

  #get 'contacts' => 'contacts#new', as: :contacts
  #post 'contacts' => 'contacts#create', as: :create_contacts
  #get 'contacts/sent' => 'contacts#sent', as: :contacts_sent

  #get 'search' => 'search#index', as: :search

  #resources :news, only: [:index, :show]

  root to: 'home#index'

  get '*slug' => 'pages#show'
  resources :pages, only: [:show]
end
