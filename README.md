# ganeti-cookbook

This cookbook is designed to install Ganeti.

## Supported Platforms

* CentOS 6
* Ubuntu 12.04
* Debian 7

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['ganeti']['version']</tt></td>
    <td>String</td>
    <td>Ganeti version to install</td>
    <td><tt>nil</tt></td>
  </tr>
  <tr>
    <td><tt>['ganeti']['hypervisor']</tt></td>
    <td>String</td>
    <td>Hypervisor to install and use. KVM is currently only supported</td>
    <td><tt>kvm</tt></td>
  </tr>
</table>

## Usage

### ganeti::default

Include `ganeti` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ganeti::default]"
  ]
}
```

## TODO

* Cluster initialization
* RAPI users
* Configure ``lvm.conf`` with filters for the drbd devices

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Oregon State University (<chef@osuosl.org>)
