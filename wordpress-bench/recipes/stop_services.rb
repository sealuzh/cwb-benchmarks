execute 'stop-mysql-and-apache2' do
  command 'sudo service apache2 stop; sudo service mysql-default stop'
  action :run
end
