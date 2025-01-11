require "active_model_serializers"

module Rapidfire
  class Engine < ::Rails::Engine
    # engine_name 'rapidfire'
    isolate_namespace Rapidfire

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    def self.draw_routes
      Engine.routes.draw do
        namespace :api do
          namespace :v1 do
            resources :surveys do
              member do
                get "attempts"
                get "attempts/:attempt_id", to: "surveys#show_attempt", as: "attempt"
              end
              resources :attempts, only: [:new, :create, :edit, :update, :show]
            end
          end
        end

        root to: "surveys#index"
      end
    end
  end
end
