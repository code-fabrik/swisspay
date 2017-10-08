Swisspay::Engine.routes.draw do
  resource :paypal, only: [:create, :show]
  resource :stripe, only: [:create]
  resource :postfinance, only: [] do
    get :accept
    get :cancel
    get :decline
    get :exception
  end

  resource :saferpay, only: [] do
    get :success
    get :fail
    post :start
  end
end
