#!/usr/bin/env sh
bm=stream && phoronix-test-suite batch-install pts/$bm && phoronix-test-suite batch-run pts/$bm | tee tmp/$bm.log
