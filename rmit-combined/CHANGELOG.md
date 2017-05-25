# 1.4.0 (2017-05-24)

* Fix erroneous reported number of CPU cores
* Fix refactoring string interpolation error (patched)
* Finally fix the cpu cores bug by using `['cpu'][total]` according to [ohai](https://github.com/chef/ohai/blob/master/lib/ohai/plugins/linux/cpu.rb) and manual investigation of the ohai reports for various instances types

# 1.3.0 (2017-05-17)

* Fix wrong fio metric name: `fio/8k-rand-write` => `fio/8k-rand-read`
* Refactor benchmark plugins

# 1.2.0 (2017-04-13)

* Bump `wordpress-bench` dependency.
    * **WARNING**: MUST provide a data set cookbook (example `test-plan-aws-pv`) and add it BEFORE `rmit-combined` in the Chef run list!

# 1.1.0 (2017-04-10)

* Unify metric names
* Add additional metrics to track the total time and execution progress

# 1.0.0 (2017-03-29)

* Add wordpress-bench

# 0.1.4 (2017-03-29)

* Add iperf
* Add molecular-dynamics-simulation
* Add stop-services

# 0.1.3 (2017-03-28)

* Add stress-ng: cpu, network

# 0.1.2 (2017-03-28)

* Add fio

# 0.1.1 (2017-03-27)

* Add sysbench: cpu, memory, threads, mutex, fileio

# 0.1.0 (2017-03-25)

* Initial release of `rmit-combined`
