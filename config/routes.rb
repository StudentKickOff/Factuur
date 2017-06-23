Rails.application.routes.draw do
  get '/', to: redirect('/invoices')
  get '/invoice/preview', to: 'invoice#generate'

  resources :invoices

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
