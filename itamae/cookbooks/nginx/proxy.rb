template '/etc/nginx/conf.d/proxy.conf' do
  owner 'root'
  group 'root'
  mode '644'
  notifies :run, 'execute[nginx try-reload]'
end
