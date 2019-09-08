deploy_key = '/tmp/deploy.key'

remote_file deploy_key do
  owner node[:user]
end

git_ssh = '/usr/local/bin/git-ssh'

file git_ssh do
  owner 'root'
  mode '0755'
  content %Q(#!/bin/sh\nexec ssh -oIdentityFile=#{deploy_key} -oStrictHostKeyChecking=no "$@")
end

execute 'deploy app' do
  user node[:user]
  command <<"EOC"
GIT_SSH=#{git_ssh} git pull
rm #{node[:deploy_to]}/webapp
ln -sf #{node[:deploy_to]}-tmp/app/webapp #{node[:deploy_to]}/webapp
ln -sf /home/isucon/isucari-orig/webapp/sql/initial.sql /home/isucon/isucari-tmp/app/webapp/sql/
ln -sf /home/isucon/isucari-orig/webapp/public/upload/ /home/isucon/isucari-tmp/app/webapp/public/
EOC
  cwd "#{node[:deploy_to]}-tmp"

  notifies :run, 'execute[app restart]'
end

execute 'bundle i' do
  user node[:user]
  command <<"EOC"
~/local/ruby/bin/bundle install --path=vendor/bundle
EOC
  cwd "#{node[:deploy_to]}/webapp/ruby"
end

execute 'chown static' do
  command 'chown www-data:www-data -R /srv/static'
end

execute 'app restart' do
  command node[:app_restart]
  action :nothing
end

execute 'daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end
