include_recipe 'wordpress-bench::install'
include_recipe 'wordpress-bench::generate_fake_data'
include_recipe 'wordpress-bench::configure_remote_client'
