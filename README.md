# cwb-cookbook

TODO: Enter the cookbook description here.

## TODO

* Resource naming: benchmark vs benchmark_file (à la cookbook_file)
* Library naming: BenchmarkUtil vs ... (Benchmark is already taken from the cwb client gem!)

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
