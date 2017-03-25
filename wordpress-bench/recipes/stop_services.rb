services = %w(apache2 mysql-default perfmon)
services.each do |service_name|
  service service_name do
    action :stop
  end
end
