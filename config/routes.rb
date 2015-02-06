Rails.application.routes.draw do
  root to: 'home#show'

  scope format: 'json' do
    resources :users, only: [:index]
    resources :stories, only: [:index, :show] do
      post ':aspect/unlock' => :unlock, on: :member
    end
  end
end
