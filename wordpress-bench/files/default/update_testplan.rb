#!/usr/bin/env ruby

require 'open-uri'
require 'pry' # set debugger breakpoint with `binding.pry`

# This Ruby script helps to migrate the test scenarios to a new data set.
# Provide the `site` IP or hostname of the new running instance and the script tries to
# automatically remap the jpg URLs for the new data set.

### Assumptions
# I) Requests MUST be named according to `[UID] [REQUEST_PATH]` such as:
#    `testname="31 /wp-content/uploads/2017/01/d5fd3cca-d1af-3d48-9a1a-62161a68f856.jpg"`
#    where UID=31 and REQUEST_PATH=/wp-content/uploads/2017/01/d5fd3cca-d1af-3d48-9a1a-62161a68f856.jpg

### Usage
# 1) Update the `site` variable to a server running Wordpress with the target data set
# 2) Run `./update_testplan.rb`
# 3) Disable all jpeg samplers in the request ID list `excess_source_jpgs`

### BEGIN Configuration ###

# [MANDATORY]
site = ENV['SITE'] || '127.0.0.1'
puts "Updating test_plan against site #{site}"

# [OPTIONAL]
# The filename of the test plan to update
test_plan_file = './test_plan.jmx'

# Collection of request IDs
urls = {
  "http://#{site}/" => [31, 10, 19, 14, 24, 12, 28, 23, 26],
  "http://#{site}/?cat=2" => [67, 81, 78, 89, 85, 74, 80, 87, 88, 71],
  "http://#{site}/?p=89" => [111, 110]
}

### END Configuration ###

# Collect old request IDs exploiting Assumption I)
test_plan = File.read(test_plan_file)
source_regex = %r{(\d+)\s(/wp-content/uploads/20\d\d/\d\d/[0-9a-z\-]+.jpg)}
sources = test_plan.scan(source_regex)

# Create source_jpgs hash: [request ID] => [request URL]
source_jpgs = {}
sources.each do |source|
  source_jpgs[source[0].to_i] = source[1]
end

# Collect new jpg URLs from the target server
target_jpgs = {}
id_counter = 1
target_regex = %r{/wp-content/uploads/20\d\d/\d\d/[0-9a-z\-]+.jpg}
urls.keys.each do |url|
  response = open(url).read
  targets = response.scan(target_regex)
  target_jpgs[url] = {}
  targets.each do |target|
    target_jpgs[url][id_counter] = target
    id_counter += 1
  end
end
# Flatten new URLs for easy mapping
target_jpgs_flat = {}
target_jpgs.each do |url, id_hash|
  id_hash.each do |key, value|
    target_jpgs_flat[key] = value
  end
end

### Legacy manual mapping for the case the automated mapping fails somehow
# Define manual mappings between source and target jpgs based on the
# test plan IDs encoded in testname
# manual_mappings = {
#   31 => 1,
# }
# manual_mappings.each do |key, value|
#   test_plan.gsub!(source_jpgs[key], target_jpgs_flat[value])
# end

excess_source_jpgs = []
excess_target_jpgs = []
# Use automated mappings based on the URL groups
urls.each do |url, id_list|
  id_list.zip(target_jpgs[url].keys).each do |id, key|
    if id.nil?
      excess_target_jpgs << key
    elsif key.nil?
      excess_source_jpgs << id
    else
      test_plan.gsub!(source_jpgs[id], target_jpgs[url][key])
    end
  end
end

# Possible extension
# Automatically disable all `excess_source_jpgs` samplers
# `testname="87 /wp-content/uploads/2015/06/49a9f2d7-8f6f-37c2-84aa-f1bb67f7995e.jpg" enabled="true"`
# `testname="[ID] /wp-content/uploads/2015/06/49a9f2d7-8f6f-37c2-84aa-f1bb67f7995e.jpg" enabled="false"`

### OUTPUT
# Example: excess_source_jpgs=[87, 88, 71, 110]
# => Manually disable them in the test plan.
puts "excess_source_jpgs=#{excess_source_jpgs.to_s}" unless excess_source_jpgs.empty?
# You might want to create a new sampler for all these jpegs that are in the data set but not present in the test plan
puts "excess_target_jpgs=#{excess_target_jpgs.to_s}" unless excess_target_jpgs.empty?

new_test_plan_file = File.basename(test_plan_file, ".jmx")
File.write("#{new_test_plan_file}_new.jmx", test_plan)
