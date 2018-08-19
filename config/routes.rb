Rails.application.routes.draw do
  root to: "univ_classes#index"
  
  resources :univ_classes, only: [:index]

  resources :users, only: [:show] do
    resources :univ_classes, only: [:index, :show, :update, :destroy] do
      collection do
        get :search
      end
    end
  end
  post "/univ_classes/import", to: 'univ_classes#import'
  #/users/:id/univ_classes/search　これはエラー。users/:user_id/univ_classes/searchじゃないとだめ！！idはuniv_class_idと認識されてしまう。注意
  # get "/users/:id/univ_classes/search", to: 'univ_classes#search'
end
