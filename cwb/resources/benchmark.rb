actions :install, :create, :add, :delete, :remove, :cleanup, :benchmarks_file
default_action :install

NON_EMPTY_REGEX = /^[^$|\s+]/
attribute :name, :kind_of => String, :name_attribute => true, :regex => NON_EMPTY_REGEX

# Related to delegation to cookbook_file platform resource
attribute :cookbook, :kind_of => String
attribute :source, :kind_of => String
