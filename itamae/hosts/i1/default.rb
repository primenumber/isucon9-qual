%w(
/etc/nginx/sites-enabled/isucari.conf
).each do |f|
  template f do
    owner 'root'
    group 'root'
    mode '644'
    notifies :run, 'execute[nginx try-reload]'
  end
end
