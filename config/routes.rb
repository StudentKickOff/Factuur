Rails.application.routes.draw do
  get '/', to: redirect('/invoices')
  get '/invoices/preview', to: 'invoices#preview'

  resources :invoices, only: [:index, :new, :create, :show, :destroy]
  resources :contacts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
