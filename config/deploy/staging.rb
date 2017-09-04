set :stage, :staging
set :rails_env, :staging
set :user, 'profotest'
set :application, 'profotest'

server '185.22.61.115', user: 'profotest', roles: %w{web app db}
