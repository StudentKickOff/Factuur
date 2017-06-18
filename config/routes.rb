Rails.application.routes.draw do
  get '/', to: redirect('/invoice')
  get '/invoice/preview', to: 'invoice#generate'

  resources :invoice

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
