# cwb-cookbook

TODO: Enter the cookbook description here.

## Dev (getting more serious)

* Use Github issue tracker
* Refer and link to tickets within commit messages
* Write CHANGELOG.md (mainly covers what changes from a user's perspective) and link to ticket
* Propose improved Git repository layout
  * At least distinguish between [cwb-server], [cwb-client], [cwb-cookbook]
  * How can a cookbook repo be easily managed?
  * The cleanest option would be to have a separate repository for each cookbook and then maybe a sealuzh-cloud-workbench organization to manage permissions at this level. However, it might be more pragmatic though to have all cookbooks within one repository
  * SUGGESTION
    * [cwb-server] cloud-workbench: existing repo; contains cwb-server cookbook for installation
    * [cwb-client] cloud-workbench-client or cwb-client: client utility gem
    * [cwb-benchmarks] benchmark-cookbooks or cwb-benchmarks: actual benchmarks (does not contain any community cookbooks! => Provide Berkshelf quick guide, should pass --no-git option!, document FAQ such as SSL validation config + .DS_Store issue on Mac https://github.com/berkshelf/berkshelf/issues/706)
    * Where should the cwb cookbook that installs the client utility on cloud servers live?
      * cwb-server: (+) belongs to the cwb infrastructure
      * cwb-client: (+) would be logical that the client knows how to install itself on a cloud VM
      * cwb-benchmarks: (+) easy to upload => seems logical to look for cookbooks here; (-) not really a benchmark

## TODO

* Resource naming: benchmark vs benchmark_file (à la cookbook_file)
* Library naming: BenchmarkUtil vs ... (Benchmark is already taken from the cwb client gem!)
* deep_fetch: might be better to return nil instead of '' in order to be able to distinguish between empty and non-existing attribute
* Provide examples
  *  Simple getting started ("one-liner")
  *  More advanced using the Cwb::BenchmarkUtil utility
  *  Debugging with binding.pry
  *  Local: Vagrant/test-kitchen "sudo -E /opt/chef/bin/chef-solo --config /tmp/kitchen/solo.rb --log_level auto --force-formatter --no-color --json-attributes /tmp/kitchen/dna.json"
* [cwb-cli] Log errors to stderr instead of stdout; Improve cwb cli utility error messages => include suggestions
* cwb cli might be able to recognize suites the same way as benchmarks (point to file instead of directory)
* cwb cli might support directory path for benchmark (i.e. benchmark path)
* DOCS: provide basic (getting started with a minimal example) + advanced guide
  * Example with the Benchmark Ruby library
  * Local testing with Vagrant/test-kitchen
* Handle case where cwb.server (i.e., cwb-server IP) is available but instance requrests failed
* Support node.yml for local testing (i.e., just beside a local benchmark file, may provide a cwb command to generate one from attributes/default.rb) => Keep in mind that the cwb utility should be kept as small as possible because it is loaded during benchmark execution!
* Simplify cwb-server installation!!!
  * Improve installation cookbook (dependency hell!)
  * ADVICE: "Idempotent systems are better than idempotent records" => design data driven cookbooks!
  * Consider providing a Docker image!
* [cwb-cookbook] smarter implementation of updated_by_last_action notification method similar to: https://docs.chef.io/lwrp_custom_provider.html#updated-by-last-action

## Improvements

* Add the utility command cwb ssh IP to ssh into cwb instances => provide cloud-benchmarking.pem path in config or as arg!
* Provide a mechanism for benchmark repetitions
* Provide mechanism to post/or sync back logging within the VM
* Provide automatic metric collection (e.g., for CPU model name), maybe also for other Ohai attributes such as network or io counters
* Replace data bag with parameter passing from default Vagrantfile via the reserved cwb namespace for save merge! => may prefix and suffix Vagrantfile
* Provide (extensible) CliBenchmark cookbook that allows to define cookbook-less benchmarks (only via web interface)
* Provide utilities for multi-VM benchmarks
* Improve reuse of class via DI into the constructor (at least for Benchmark) instead of relying on inheritance => Sample use in BenchmarkSuite
  * Example: sysbench = Sysbench.new(cwb_client)
  * Simpler execution in BenchmarkSuite instead of akward query mechanism to existing benchmark instances à la: @cwb.execute(sysbench) => User should not handle working_directory issues (but might override the settings)
* Reuse Cwb::BenchmarkUtil between cwb cookbook and cli
* Improve cwb cli + cookbook validation (e.g., no special characters, Ruby class validation via repond_to?, or linting for a) naming patterns b) inheritance < Cwb::Benchmark c) execute/execute_suite method )
* Delegate execution to client of correct execute_in_working_dir handling
* Parameter passing into run => How can we implement passing the repetition number?!
* Filter node hash (if necessary)
* Take a look how Chef-zero could be used for testing
* [cwb-server] Reprovision button should not start execution (this would be bad during development)

## Issues

* Non-uniform VM identification might be an issue with multi VM benchmarks
  * Multi-VM benchmarks won't currently work in GCE because the VM identifier is not unique in execution scope!
  * Technical constraints: Currently, VM detection is done server-side (i.e., on the cwb-server) based on the Vagrant file system structure
  * ACTUAL: provider + provider_id is used to identify VM
    * Vagrant: .vagrant/ROLE/PROVIDER/id contains:
    * aws: instance_id (query via API within cloud VM)
    * gce: instance_id (pass metadata in Vagrantfile and query via API within cloud VM)
    * virtualbox: some long hash ID (NOT SOLVED HOW TO GET THIS FROM WITHIN THE VM!?)
  * OPTIONS:
    * a) Vagrant role-based (- hard/impossible? to resolve on cloud VM)
    * b) Chef node name (- server-side detection not feasible => maybe during the Chef run every VM should register itself at the cwb-server; not necessarily entirely unique, e.g., deleted clients/nodes on the Chef server can be recreated!)
    * c) Add cwb-specifc VM identifier (- cannot be controlled on VM level)
  * Authentication: Chef client key might be used, it gets generated on the Chef server, if one copies the private key to the cwb-server, the client.pem could serve as authentication key.


## Supported Platforms

TODO: List your supported platforms.

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['cwb']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### cwb::default

Include `cwb` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[cwb::default]"
  ]
}
```

## License and Authors

Author:: YOUR_NAME (<YOUR_EMAIL>)
