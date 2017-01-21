# 2.0.0 (2017-01-22)

* Leverage the `joe4dev/wordpress` cookbook for WordPress setup and plugin install. This is not part of the benchmark cookbook anymore.

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
