Rails.application.routes.draw do
  mount TiboCore::Engine => "/tibo_core"

  root to: 'pages#home'
end
