# config/unicorn.rb
app_path = '/home/rails/www/pohody.com.ua/current'

listen "#{app_path}/tmp/sockets/unicorn.sock"
stderr_path "#{app_path}/log/unicorn.stderr.log"
working_directory app_path
pid "#{app_path}/tmp/pids/unicorn.pid"
worker_processes 2
timeout 15
preload_app true
before_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.connection.disconnect!
end
after_fork do |_server, _worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
  defined?(ActiveRecord::Base) &&
    ActiveRecord::Base.establish_connection
end
