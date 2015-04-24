# Cloud WorkBench (CWB) Cookbooks

The [Chef Cookbooks](http://docs.chef.io/cookbooks.html) within this repository install and configure benchmarks that are aimed to be used with [Cloud WorkBench](https://github.com/sealuzh/cloud-workbench).


## Local Cookbook Dependencies

Use the `helper.rb` utility to resolve dependencies among your custom cookbooks:

1. Import the helper at the very beginning of your Berksfile

    ```ruby
    require_relative "../helper"
    ```

2. Specify your local cookbook dependencies within your Berksfile

    ```ruby
    local_cookbook "my-first-benchmark"
    ```
