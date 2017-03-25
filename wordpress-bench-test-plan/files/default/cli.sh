#!/usr/bin/env bash
jmeter --nongui --testfile test_plan.jmx --logfile test_plan.jtl --addprop local.properties
