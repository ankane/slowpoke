Rails.application.routes.draw do
  get "timeout" => "users#timeout"
  get "admin" => "users#admin"
end
