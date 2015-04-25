def install(packages)
  packages.each do |pkg|
    package pkg do
      action :install
    end
  end
end

packages = node['cli-benchmark']['packages']
# Also support single strings (i.e., no array)
packages = [ packages ] if packages.class == String

if packages.any?
  include_recipe 'apt'
  install(packages)
end
