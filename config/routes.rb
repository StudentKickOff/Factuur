Rails.application.routes.draw do
  get '/', to: redirect('/notes')
  get '/notes/preview', to: 'notes#preview'

  post '/contacts/:id/unarchive', to: 'contacts#unarchive'
  post '/notes/:id/unarchive', to: 'notes#unarchive'

  resources :notes, only: [:index, :new, :create, :show, :destroy]
  resources :contacts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
