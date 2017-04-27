bash 'dummy-delay' do
  code 'true'
  # Dummy resource to notify/subscribe delayed execution
end

services = %w(apache2 mysql-default perfmon)
services.each do |service_name|
  service service_name do
    action :nothing
    # Make sure that services that get restarted (e.g., apache2)
    # in a delayed manner also get stopped delayed at the end of the Chef run
    # Example: apache2 gets restarted delayed because of:
    # a) template[/etc/apache2/ports.conf] sending restart action to service[apache2] (delayed)
    # b) template[/etc/apache2/sites-available/wordpress.conf] sending reload action to service[apache2] (delayed)
    subscribes :stop, 'bash[dummy-delay]', :delayed
  end
end
