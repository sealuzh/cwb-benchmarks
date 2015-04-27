DEFAULT_SERVER = 'localhost'
POLLING_INTERVAL = 60 # seconds

def poll_for_server
  node_id = node["iperf"]["server_node_name"]
  server_ip = nil
  while server_ip.nil?
    node_list = search(:node, "name:#{node_id}", :filter_result => { 'server_ip' => [ 'ec2', 'public_ipv4' ] })
    server_ip = node_list.first['server_ip'] rescue nil
    if server_ip.nil?
      sleep(POLLING_INTERVAL)
    else
      return server_ip
    end
  end
end

if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search. Using '#{DEFAULT_SERVER}' as server.")
  node.default['iperf']['server'] = node['iperf']['server'] || DEFAULT_SERVER
else
  node.default['iperf']['server'] = node['iperf']['server'] || poll_for_server
end

cwb_benchmark 'iperf'
