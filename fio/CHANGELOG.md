# fio-benchmark CHANGELOG

# 1.0.0 (2015-04-25)

* Major update to support the improved cwb version
    * The cwb client utility now support local testing
    * Use test-kitchen instead of Vagrant for automated integration testing
* Renamed cookbook `fio-benchmark` to `fio`

## 0.3.1 (2014-12-01)

* Add sample Vagrantfiles for aws (for use with CWB) and virtualbox (standalone)
* Improve README

## 0.3.0 (2014-06-19)

* Replace start and postprocessing shell scripts with Ruby scripts
* Move fio_log_parser to files since it is no template
* Add generic attribute support for fio job ini file
* Additionally submit cpu type metric


## 0.2.0 (2014-04-22)

* Add more configuration options and refactor generic benchmark related utilities into own benchmark cookbook.

## 0.1.0 (2014-03)

*  Initial release of fio-benchmark