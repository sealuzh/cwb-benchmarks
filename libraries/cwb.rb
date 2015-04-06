class Chef::Recipe::Cwb
  def self.cwb_log
    Chef::Log.warn 'Cwb log'
  end

  # Method calls only available in a resource context must be
  # executed in their context. Therefore, this method takes
  # the context as block, defines a block and executes that
  # block in the given context.
  def self.my_defaults(con)
    lambda do |context|
      Chef::Log.warn "CODE FROM BLOCK!"
      context.owner 'vagrant'
      self.check_for_group(context)
      context.mode 0777
    end.call(con)
  end

  def self.check_for_group(context)
    if context.respond_to?(:group)
      Chef::Log.warn "context responds to group"
        context.group 'vagrant'
     end
  end

  def my_method
    Chef::Log.warn "From instance method!"
  end

  def my_content
    "#!/usr/bin/env ruby\nputs 'content from instance object'"
  end
end
