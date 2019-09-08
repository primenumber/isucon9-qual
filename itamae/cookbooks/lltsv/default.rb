execute 'install lltsv' do
  command 'wget -O /usr/local/bin/lltsv https://github.com/sonots/lltsv/releases/download/v0.6.1/lltsv_linux_amd64 && chmod +x /usr/local/bin/lltsv'
  not_if 'test -e /usr/local/bin/lltsv'
end
