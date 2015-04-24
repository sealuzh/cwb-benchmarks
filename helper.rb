# @return [String] the absolute path to the directory
#                  wherein all cwb cookbooks reside
# @example cookbooks_dir #=> "/Users/MyUsername/git/cwb-cookbooks"
def cookbooks_dir
  File.expand_path("..", __FILE__)
end

# Specifies a berkshelf cookbook dependency to a local cookbook
# @note assumes the following directory structure:
#       cwb-benchmarks
#       ├── my-first-benchmark
#           ├── Berksfile
#       ├── my-second-benchmark
#           ├── Berksfile
#       ├── ...
#
# @example
# 1) Import this helper at the very beginning of your Berksfile
# require_relative "../helper"
# 2) Specify a local cookbook dependency within your Berksfile
# local_cookbook "my-first-benchmark"
def local_cookbook(name)
  cookbook name, path: File.join(cookbooks_dir, name)
end
