### Install wordpress
# Need to be set in attributes because it needs to be available at attribute resolution time
# in the `wordpress` cookbook as the download url is a dependent attribute!
 # ['wordpress']['version'] = '4.7.1'
node.default['wordpress']['wp_config_options'] = { 'AUTOMATIC_UPDATER_DISABLED' => true }
node.default['wordpress']['plugins'] = {
  disable_check_comment_flood: 'disable-check-comment-flood',
  fakerpress: 'https://github.com/bordoni/fakerpress/archive/0.3.1.zip'
}
node.default['wordpress']['site']['title'] = 'WordPress Benchmark'
include_recipe 'wordpress::setup'
