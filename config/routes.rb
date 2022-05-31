Rails.application.routes.draw do
  resources :resources
  resources :contacts
  resources :likes
  resources :collections

  authenticated :user, ->(user) { user.admin? } do
    get 'admin', to: 'admin#index'
    get 'admin/uploads'
    get 'admin/users'
    get 'admin/show_upload'
  end

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  get 'users/profile'
  get '/u/:id', to: 'users#profile', as: 'user'

  resources :uploads do
    resources :likes
  end

  resources :uploads do
    member do
      patch :update_status
    end
  end
  
  
  get 'manage', to: 'uploads#manage'

  resources :uploads
  resources :tags
  
  get 'search', to: 'search#index'
  get 'archive', to: 'uploads#index'
  get 'about', to: 'pages#about'
  get 'contact', to: 'contacts#new'
  get 'resources', to: 'pages#resources'

  root 'pages#landing'
end
