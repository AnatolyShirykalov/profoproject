set :stage, :production
set :rails_env, :production

server '185.22.61.115', user: 'profoproject', roles: %w{web app db}
