# Install wordpress
node.default['wordpress']['version'] = '4.7.1'
node.default['wordpress']['wp_config_options'] = { 'AUTOMATIC_UPDATER_DISABLED' => true }
node.default['wordpress']['plugins'] = {
  disable_check_comment_flood: 'disable-check-comment-flood',
  fakerpress: 'https://github.com/bordoni/fakerpress/archive/0.3.1.zip'
}
node.default['wordpress']['site']['title'] = 'WordPress Benchmark'
include_recipe 'wordpress::setup'
