# Execution time in seconds
default['iperf']['time'] = 300
# Chef client node name of the iperf server (pass via Vagrantfile)
default['iperf']['server_node_name'] = /.*-iperf-server/
# Directly pass the server ip or hostname if available
default['iperf']['server'] = nil
