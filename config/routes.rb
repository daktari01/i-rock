Rails.application.routes.draw do
  resource :achievement, only: [ :new, :create ]
  root to: 'welcome#index'
end
