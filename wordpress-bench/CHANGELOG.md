# 2.1.0 (2017-03-29)

* Use new notification scheme. Upon completed execution, the load-generator (i.e., `wordpress-bench-client.rb`) instance now notifies the server where Wordpress is installed that the load testing is completed using a TCP connection.
* Remove `http://` prefix for load-generator config
* Update testplan according to `wordpress-bench-test-plan` (see CHANGELOG up to `0.1.5` there)

# 2.0.4 (2017-03-14)

* Add support and docs for distributed testing mode

# 2.0.3 (2017-03-14)

* Adjust result calculation

# 2.0.2 (2017-03-13)

* Add perfmon support (stop, start process). Add the `perfmon` recipe to install and enable the perfmon service.

# 2.0.1 (2017-03-07)

* Use JMeter 3.1
* Improve modularization to support "test plan cookbooks". Allow to create a seperate cookbook that encapsulates other test plans.
* Update testplan to support currency thread group using the JMeter plugin `jpgc-casutg`

# 2.0.0 (2017-01-27)

* Leverage the `joe4dev/wordpress` cookbook for WordPress setup and plugin install. This is not part of the benchmark cookbook anymore.
* Update the `test_plan` for the new data set
* Update Vagrantfile examples

# 0.1.3 (2017-01-10)

* Bump outdated nokogiri gem dependency causing installation error

# 0.1.2 (2015-07-22)

* Additionally report failure metrics `num_failures` and `failure_rate`

# 0.1.1 (2015-07-01)

* Fix create-comment scenario with random number (or alternatively counter) suffix
* Remove duplicated search scenario within the read-only scenario
* Make `num_repetitions` configurable
* Make `num_threads` and `ramp_up_period` configurable
* Add the Wordpress plugin `disable-check-comment-flood` to fix the error within the create-comment scenario

# 0.1.0 (2015-06-09)

* Initial release of `wordpress-bench`
