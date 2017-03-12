## Installation
default['perfmon']['version'] = '2.2.1'
default['perfmon']['source_url'] = "https://jmeter-plugins.org/downloads/file/ServerAgent-#{node['perfmon']['version']}.zip"
# SHA-256 checksum: `shasum -a 256`
default['perfmon']['checksum'] = '2d5cfd6d579acfb89bf16b0cbce01c8817cba52ab99b3fca937776a72a8f95ec'

## Runtime
default['perfmon']['service'] = 'enable' # or 'disable' according to https://github.com/poise/poise-service#actions
default['perfmon']['user'] = (node['benchmark']['ssh_username'] rescue 'root')
default['perfmon']['cli_args'] = '--udp-port 0 --tcp-port 4444'
