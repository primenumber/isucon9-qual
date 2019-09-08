execute 'install netdata' do
  command 'wget -O/tmp/netdata.sh https://my-netdata.io/kickstart.sh; chmod +x /tmp/netdata.sh; /tmp/netdata.sh --non-interactive'
  not_if 'test -e /etc/netdata'
end
