Rapidfire::Engine.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :surveys do
        member do
          get "attempts"
          get "attempts/:attempt_id", to: "surveys#show_attempt", as: "attempt"
        end
        resources :questions
        resources :attempts, only: [:new, :create, :edit, :update, :show]
      end
    end
  end

  resources :surveys do
    member do
      get "results"
    end
    get "results/:id", to: "surveys#show_result", as: "result"
    resources :questions
    resources :attempts, only: [:new, :create, :edit, :update, :show]
  end

  root to: "surveys#index"
end
