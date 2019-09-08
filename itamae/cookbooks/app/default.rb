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

directory '/srv/static' do
  owner 'nginx'
end

execute 'deploy app' do
  user node[:user]
  command <<"EOC"
GIT_SSH=#{git_ssh} git pull
cp -rf /home/isucon/torb-tmp/app/webapp/static/* /srv/staticrm #{node[:deploy_to]}/webapp
ln -sf #{node[:deploy_to]}-tmp/app/webapp #{node[:deploy_to]}/webapp
EOC
  cwd "#{node[:deploy_to]}-tmp"
end

execute 'bundle i' do
  user node[:user]
  command <<"EOC"
~/local/ruby/bin/bundle install --path=vendor/bundle
EOC
  cwd "#{node[:deploy_to]}/webapp/ruby"
end

execute 'copy static' do
  command 'cp -rf /home/isucon/torb-tmp/app/webapp/static/* /srv/static'
  not_if 'test -e /srv/static/favicon.ico'
end

execute 'chown static' do
  command 'chown nginx:nginx -R /srv/static'
end

execute 'app restart' do
  command node[:app_restart]
  action :nothing
end

execute 'daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

remote_file '/etc/systemd/system/torb.ruby.service' do
  notifies :run, 'execute[daemon-reload]'
end
