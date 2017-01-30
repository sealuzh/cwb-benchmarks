services = node['stop-services']['stop_list']
services.each do |service_name|
  service service_name do
    action :stop
  end
end
