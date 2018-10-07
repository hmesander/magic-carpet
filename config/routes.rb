Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'adventures', to: 'adventures#create'
      post 'users', to: 'users#create'
    end
  end
end
