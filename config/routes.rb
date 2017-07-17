Rails.application.routes.draw do
  get '/', to: redirect('/invoices')
  get '/invoices/preview', to: 'invoices#preview'

  post '/contacts/:id/unarchive', to: 'contacts#unarchive'
  post '/invoices/:id/unarchive', to: 'invoices#unarchive'

  resources :invoices, only: [:index, :new, :create, :show, :destroy]
  resources :contacts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
