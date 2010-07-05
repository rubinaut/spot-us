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


task :tail_logs, :roles => :app do
  stream "tail -n 1000 -f #{current_path}/log/production.log"
end

# For Passenger
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :update_gems, :except => { :no_release => true } do
    run "cd #{current_path}; sudo RAILS_ENV=#{rails_env} rake gems:install --trace"
  end

  ################
  #              #
  #   DB Tasks   #
  #              #
  ################
  task :migrate, :roles => :db, :except => { :no_release => true } do
    run "cd #{current_path}; rake RAILS_ENV=#{rails_env} db:migrate --trace"
  end

  task :db_create, :roles => :db, :except => { :no_release => true } do
    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:create"
  end

  ################
  #              #
  # Apache Tasks #
  #              #
  ################
  namespace :apache do
    task :start, :roles => :app do
      sudo "/etc/init.d/apache2 start"
    end

    task :stop, :roles => :app do
      sudo "/etc/init.d/apache2 stop"
    end

    task :restart, :roles => :app do
      sudo "/etc/init.d/apache2 restart"
    end

    task :access_logs, :roles => :app do
      stream "tail -n 1000 -f /var/log/apache2/*.production.log"
    end

    task :error_logs, :roles => :app do
      stream "tail -n 1000 -f /var/log/apache2/error.log"
    end
  end

  CONFIG_FILES = %w(database settings)
  desc "Copies the initial configuration files to the shared directory"
  task :copy_config_templates, :except => {:no_release => true} do
    run "mkdir -p #{shared_path}/config"

    CONFIG_FILES.each do |file|
      run "cp #{release_path}/config/#{file}.example.yml #{shared_path}/config/#{file}.yml"
    end
  end

  desc "[internal] Updates symlinks to configurations files"
  task :symlink_config_templates, :except => {:no_release => true} do
    CONFIG_FILES.each do |file|
      run "ln -nfs #{shared_path}/config/#{file}.yml #{release_path}/config/#{file}.yml"
    end
  end
end

after "deploy:setup", "deploy:copy_config_templates"
after "deploy:finalize_update", "deploy:symlink_config_templates"
