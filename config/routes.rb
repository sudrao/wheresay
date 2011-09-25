Wheresay::Application.routes.draw do
  resource :here
  root :to => 'heres#show'
end
