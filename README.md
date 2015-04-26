# Cloud WorkBench (CWB) Benchmarks

The [Chef Cookbooks](http://docs.chef.io/cookbooks.html) within this repository install and configure benchmarks that are aimed to be used with [Cloud WorkBench](https://github.com/sealuzh/cloud-workbench).

## Setup

1. Clone this repository

    ```bash
    cd $HOME/git
    git clone https://github.com/sealuzh/cwb-benchmarks.git
    ```

2. Install the Chef Development Kit from https://downloads.chef.io/chef-dk/

3. Configure Chef `knife` and Berkshelf `berks` tools
    1. Update `CHEF_SERVER` and `REPO_ROOT` within `knife.rb`

        ```bash
        vim config/knife.rb
        ```

    2. Copy `knife.rb` to `~/.chef/knife.rb` and `config.json` to `~/.berkshelf/config.json`

        ```bash
        mkdir ~/.chef && cp knife.rb $HOME/.chef/knife.rb
        mkdir ~/.berkshelf && cp config.json $HOME/.berkshelf/config.json
        ```

    3. Paste your Chef client key to `$HOME/.chef/cwb-user.pem`. Refer to https://github.com/sealuzh/cloud-workbench how to create a Chef client if you have not created one yet.

4. Verify connection to Chef Server

    ```bash
    knife client list
    ```

## Execute a basic CLI Benchmark

1. Go to your CWB-server `http://cwb-server.io/benchmark_definitions/new` (i.e., BENCHMARK > Definitions > Create New Benchmark)
2. Chose a `Name` and click `Create New Benchmark`
3. Click `Create New Metric Definition`
4. Fill in `Name=time`, `Unit=seconds`, `Scale type=Ratio`, and click `Create Metric Definition` (Optionally add another one with `Name=cpu`, `Unit=model name`, and `Scale type=Nominal`)
5. Click `Start Execution` and confirm the popup dialog.

## Schedule a benchmark

1. Within your benchmark definition, click `Create Schedule`
2. Enter your Cron expression (e.g., `* 0,12 * * *` for midnight and lunchtime every day) and click `Create Schedule`
3. Don't forget to deactivate your schedules if you don't need them anymore! Review active schedules here `http://cwb-server.io/benchmark_schedules?active=true`

## Write your first benchmark

1. Copy the benchmark cookbook template (replace `benchmark-name` approprietly)

    ```bash
    cd $HOME/git/cwb-benchmarks
    cp -r _template benchmark-name
    cd benchmark-name
    ```

2. Update `metadata.rb` to use the same `benchmark-name` as `name`

    ```bash
    vim metadata.rb
    ```

3. Update `benchmark-name` in the default recipe

    ```bash
    vim recipes/default.rb
    ```

4. Write the `install` recipe that leverages Chef to install all the benchmark dependencies. 
    * Chef resources: http://docs.chef.io/resources.html
    * Search Chef docs: https://docs.chef.io/search.html
    * Install a package (e.g., apt package on Debian system): https://docs.chef.io/resource_package.html
    * Create file: https://docs.chef.io/resource_file.html
    * Create file from cookbook: https://docs.chef.io/resource_cookbook_file.html
    * Create file from template: https://docs.chef.io/resource_template.html
    * Download file from URI: https://docs.chef.io/resource_remote_file.html
    * Create directory: https://docs.chef.io/resource_directory.html
    * Execute command: https://docs.chef.io/resource_execute.html

    ```bash
    vim recipes/install.rb
    ```

5. Write the `configure` recipe that leverages Chef and the 'cwb' cookbook to configure the benchmark for Cloud WorkBench.
   * Use the `cwb_benchmark` resource to define your benchmark.
   * Rename the file approprietly

    ```bash
    vim recipes/configure.rb
    mv files/default/benchmark_name.rb files/default/your_benchmark_name.rb
    ```

6. Write your benchmark logic as [Ruby](https://www.ruby-lang.org/) code.
    * Rename the class `BenchmarkName` using CamelCase (e.g., ssl-benchmark => SslBenchmark)
    * Your logic goes into the `execute` method hook

    ```bash
    vim files/default/your_benchmark_name.rb
    ```

7. (OPTIONAL) You might want to make your benchmark configurable via attributes that can be passed from the Vagrantfile in the CWB web interface.
    * Access attributes in a Chef recipe via `node['benchmark-name']['attribute_1']`
    * Access attributes in the Ruby class via `@cwb.deep_fetch('benchmark-name', 'attribute_1')`
    * RECOMMENDATION: It is highly recommended to use the `benchmark-name` as the namespace for your attributes. NEVER use the reserved namespaces `cwb` or `benchmark`.

    ```bash
    vim attributes/default.rb
    ```

8. (OPTIONAL) Update documentation and lint your cookbook.
    * Foodcritic will lint your cookbook and discover errors early. Find docs here: http://acrmp.github.io/foodcritic/

    ```bash
    vim README.md
    vim CHANGELOG.md
    foodcritic .
    ```

9. Upload your benchmark cookbook to the Chef Server
    * `berks upload` will freeze your cookbook version => bump version (the `--force` flag allows to overwrite already uploaded cookbooks)
    * Mac OS X users might get the following [error](https://github.com/berkshelf/berkshelf/issues/706): `Ridley::Errors::HTTPBadRequest: {"error":["Invalid element in array value of 'files'."]}` The workaround is to delete all `.DS_STORE` files within the cookbook directory via `find . -name '*.DS_Store' -type f -delete`

    ```bash
    berks install && berks upload
    ```

10. Execute your benchmark
    1. Create a new `Benchmark Definition` via the CWB Web interface (analoguous to `Execute a basic CLI Benchmark`)
    2. Create the corresponding metrics for your benchmark definition (metric names must match)

## Debug your benchmark

CWB comes with an interactive debug mode to ease benchmark development in case your benchmark fails during preparation (i.e., provisioning) or execution.

*Preparation:* Click the `Enable Keep Alive` button within your benchmark execution view.
* **WARNING:** Make sure you toggle this button once you're done because otherwise your VMs will live and cost *FOREVER*!
* CWB will automatically terminate VMs on failure after a configurable timout. Per default, you'll have 15 minutes time to enable the `Keep Alive` mode.

### Failed on preparing

1. Fix your Chef recipes by using the `Started preparing` log
2. Upload your fixed cookbooks via `berks upload` (overwrite existing versions with `--force`)
3. Click the `Reprovision` button
4. Repeat step 1. - 3. until Chef completes successfully
5. **IMPORTANT:** Click the `Disable Keep Alive` and `Abort` buttons to release all resources once you're done.

### Failed on running

1. SSH into the target VM

    ```bash
    ssh ubuntu@TARGET_HOST -i $HOME/.ssh/cloud-benchmarking.pem
    ```

2. Check log files

    ```bash
    cd /usr/local/cloud-benchmark
    cat start.log
    ```

3. Manually execute the benchmark or the entire benchmark suite

    ```bash
    cwb execute benchmark-name/benchmark_name.rb
    cwb execute .
    ```

## Advanced debugging

You can leverage the powerful [pry](http://pryrepl.org/) shell to interactively debug your Chef recipes and your benchmark code (both are plain Ruby code).

*Preparation:* Set a breakpoint anywhere in your code. Make sure you upload your updated cookbook to the Chef Server.

```ruby
require 'pry'
binding.pry
```

### Chef recipe

1. Reprovision via the CWB Web interface

2. SSH into the target VM

    ```bash
    ssh ubuntu@TARGET_HOST -i $HOME/.ssh/cloud-benchmarking.pem
    ```

2. Navigate to chef directory

    ```bash
    cd /etc/chef
    ```

3. Manually run the `chef-client`

    ```bash
    sudo chef-client -c client.rb -j dna.json
    ```

### Benchmark code

1. Simply manually start the benchmark according to `Debug your benchmark > Failed on running`

## Local testing

The `cwb` command line utility allows for "smoke-testing" benchmarks locally.
Find examples in `cli-benchmark` (local node.yml attribute config), `sysbench` ([RSpec](http://rspec.info/) unit testing), `fio` (custom config file).

```bash
gem install cwb
cwb execute benchmark-name/benchmark_name.rb
```

More sophisticated integration testing can be achieved with [Test Kitchen](http://kitchen.ci/). Have a look at `.kitchen.yml` in `sysbench` and `cli-benchmark`. In order to use this feature, you'll have to install [Virtualbox](https://www.virtualbox.org/wiki/Downloads), [Vagrant](https://www.vagrantup.com/downloads.html), and the Vagrant plugin `vagrant plugin install vagrant-omnibus`. An example integration test can be found in the `cwb` cookbook.

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
