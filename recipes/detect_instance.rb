def incomplete?
  node['benchmark']['provider_name'].empty? || node['benchmark']['provider_instance_id'].empty? rescue true
end

def detect_instance_id(instance_id_request)
  cmd = Mixlib::ShellOut.new(instance_id_request)
  cmd.run_command
  cmd.stdout
end

def update_instance
  node['benchmark']['providers'].each do |provider, config|
    instance_id = detect_instance_id(config['instance_id_request'])
    unless instance_id.empty?
      node.default['benchmark']['provider_name'] = config['name']
      node.default['benchmark']['provider_instance_id'] = instance_id
    end
  end
end

def detect
  if incomplete?
    update_instance
  end
  if incomplete?
    Chef::Log.warn('Incomplete instance identifiers. Could not detect instance.')
  end
end

detect
