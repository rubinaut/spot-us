# Some Helper tasks that you can include into deploy.rb if you like
# require File.expand_path '../../deploy/helpers', __FILE__
Capistrano::Configuration.instance(:must_exist).load do
  task :tail_logs, :roles => :app do
    stream "tail -n 1000 -f #{current_path}/log/production.log"
  end

  namespace :deploy do
    task :update_gems, :except => { :no_release => true } do
      run "cd #{current_path}; sudo RAILS_ENV=#{rails_env} rake gems:install --trace"
    end
  end
end

