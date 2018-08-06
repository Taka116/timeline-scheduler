Rails.application.routes.draw do
  root to: "univ_classes#index"

  resources :users, only: [:show] do
    resources :univ_classes, only: [:index, :show, :update]
  end
  post "/univ_classes/import", to: 'univ_classes#import'
end
