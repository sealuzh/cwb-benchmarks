#!/usr/bin/env bash
jmeter --nongui --testfile wordpress-bench.jmx --logfile wordpress-bench.jtl --addprop local.properties
