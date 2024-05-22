Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  get "dashboard/show"

  devise_for :users,
    path: '',
    controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions"
    },
    path_names: {
      sign_in: 'login',
      password: 'forgot',
      confirmation: 'confirm',
      sign_up: 'sign_up',
      sign_out: 'signout'
    }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  authenticated :user do
    root to: "dashboard#show", as: :user_root
  end

  devise_scope :user do
    root to: "devise/sessions#new"
  end

  namespace :careers do
    resources :accounts, only: %i[ show ] do
      resources :jobs, only: %i[ index show ], shallow: true
    end
  end

  resources :jobs
  resources :applicants do
    get :resume, action: :show, controller: "resumes"
    member do
      patch :change_stage
    end
    resources :emails, only: %i[ index new create show ]
    resources :email_replies, only: %i[ new ]
  end
  resources :notifications, only: %i[ index ]
end
