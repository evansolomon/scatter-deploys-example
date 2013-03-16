# Application
set :application, "appname"
set :repository, "git@github.com:myaccount/#{application}.git"

# Source control
set :scm, :git
set :deploy_to, "/srv/www/#{application}/public"
set :git_enable_submodules, 1

# Deploy
set :keep_releases, 5
set :deploy_via, :remote_cache

# Exclusions
set :copy_exclude, [".git", ".DS_Store", ".gitignore", ".gitmodules"]
server application, :app

# Sudo
set :use_sudo, true
default_run_options[:pty] = true

# nginx
namespace :nginx do
  desc "Updates nginx config"
  task :update_config, :roles => :app do
    run "#{sudo} ln -nfs #{shared_path}/cached-copy/.nginx-conf /etc/nginx/sites-enabled/#{application}"
  end

  desc "Reloads nginx"
  task :reload, :roles => :app do
    run "#{sudo} /etc/init.d/nginx reload"
  end

  desc "Restarts nginx"
  task :restart, :roles => :app do
    run "#{sudo} /etc/init.d/nginx restart"
  end
end

# PHP-FPM
namespace :php do
  desc "Reloads PHP-FPM"
  task :reload, :roles => :app do
    run "#{sudo} /etc/init.d/php5-fpm reload"
  end

  desc "Restarts PHP-FPM"
  task :restart, :roles => :app do
    run "#{sudo} /etc/init.d/php5-fpm restart"
  end
end

# WordPress
namespace :wordpress do
  desc "Symlink uploads directories"
  task :symlink, :roles => :app do
    run "ln -nfs #{shared_path}/uploads #{release_path}/wp-content/uploads"
    run "ln -nfs #{shared_path}/blogs.dir #{release_path}/wp-content/blogs.dir"
  end
end

# Hooks
after "deploy:update_code", "wordpress:symlink"
after "wordpress:symlink", "nginx:update_config"
after "nginx:update_config", "nginx:restart"
after "wordpress:symlink", "php:restart"
after "deploy:update", "deploy:cleanup"
