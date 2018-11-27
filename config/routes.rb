Rails.application.routes.draw do
  devise_for :user
  get '/user', to: redirect("/user/sign_up"), as: "user_sign_up_again"

  root to: "home#index"
  
  resources :univ_classes, only: [:index]

  resources :users, only: [:show] do
    resource :likes, only: [:show]
    resources :univ_classes, only: [:index, :show, :update, :destroy] do
      resource :likes, only: [:create, :destroy]
      collection do
        get :search
      end
    end
  end
  post "/univ_classes/import", to: 'univ_classes#import'
  #/users/:id/univ_classes/search　これはエラー。users/:user_id/univ_classes/searchじゃないとだめ！！idはuniv_class_idと認識されてしまう。注意
  # get "/users/:id/univ_classes/search", to: 'univ_classes#search'
  
  # get '*path', controller: 'application', action: 'render_404'
end
