### Install your benchmark here by leveraging
# Chef resources: http://docs.chef.io/resources.html
# Community cookbooks: https://supermarket.chef.io/dashboard

include_recipe 'apt'

package 'sysbench'
include_recipe 'rmit-combined::install_fio'
include_recipe 'rmit-combined::install_stressng'
package 'iperf'
include_recipe 'rmit-combined::install_md_sim'
