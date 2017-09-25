set :stage, :tstaging
set :rails_env, :tstaging
set :user, 'profoproject'
set :application, 'profoproject'
set :deploy_to, -> { "/data/#{fetch(:user)}/app" }

server '192.168.1.34', user: 'profoproject', roles: %w{web app db}
