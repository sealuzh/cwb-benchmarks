poise_service 'perfmon' do
  command "./startAgent.sh #{node['perfmon']['cli_args']}"
  user node['perfmon']['user']
  directory '/usr/local/perfmon'
  # environment JAVA_HOME: ...
  action node['perfmon']['service'].to_sym
end
