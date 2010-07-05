ssh_options[:forward_agent] = true

set :application, "spot-us"
set :repository,  "git@github.com:rubinaut/spot-us.git"

set :scm, :git
set :branch, "gojo"
set :deploy_via, :remote_cache
set :deploy_to, "/var/www"

# set :use_sudo, false
# set :user, "user"

role :web, "your web-server here"                          # Your HTTP server, Apache/etc
role :app, "your app-server here"                          # This may be the same as your `Web` server
role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# For Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

namespace :config do
  CONFIG_FILES = %w(database settings)

  desc "Copies the initial configuration files to the shared directory"
  task :setup, :except => {:no_release => true} do
    run "mkdir -p #{shared_path}/config"

    CONFIG_FILES.each do |file|
      run "cp #{release_path}/config/#{file}.example.yml #{shared_path}/config/#{file}.yml"
    end
  end

  desc "[internal] Updates symlinks to configurations files"
  task :symlink, :except => {:no_release => true} do
    CONFIG_FILES.each do |file|
      run "ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config/#{file}.yml"
    end
  end
end

after "deploy:setup", "config:setup"
after "deploy:finalize_update", "config:symlink"
