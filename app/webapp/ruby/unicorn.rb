worker_processes 2
working_directory "/home/isucon/isucari/webapp/ruby"

timeout 3600


listen 8000
pid "/var/run/unicorn.pid"


stderr_path "/tmp/unicorn.log"
stdout_path "/tmp/unicorn.log"

preload_app true
