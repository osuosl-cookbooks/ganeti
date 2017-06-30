# ganeti-cookbook

This cookbook is designed to install Ganeti.

## Supported Platforms

* CentOS 6
* Ubuntu 12.04
* Ubuntu 14.04

## Attributes

- `['ganeti']['version']` - Ganeti version to install. Defaults to `nil`
- `['ganeti']['hypervisor']` - Hypervisor to install and use. Defaults to `kvm`
- `['ganeti']['master-node']` - FQDN of the host that will be set as the initial
  master and will initialize the cluster. A value of `true` is also valid but
  only used for testing purposes or single master clusters. Defaults to `nil`.
- `['ganeti']['bin-path']` - Path for the Ganeti binaries. Defaults to
  `/usr/sbin/`.
- `['ganeti']['data_bag']` - Data bag name for RAPI users. Defaults to
  `rapi_users`.

### Cluster Initialization attributes
- `['ganeti']['cluster']['name']` - FQDN of the cluster. Must be resolvable.
  Defaults to `nil`.
- `['ganeti']['cluster']['disk-templates']` - Array of disk templates to be
  enabled. Defaults to `[ 'plain', 'drbd' ]`.
- `['ganeti']['cluster']['master-netdev']` - Master network device for the
  Ganeti cluster. Must exist before installing ganeti. Defaults to `br0`.
- `['ganeti']['cluster']['enabled-hypervisors']` - An array of hypervisors to
  enable in the cluster. Defaults to `[ 'kvm' ]`
- `['ganeti']['cluster']['nic']['mode']`- Default NIC mode for the guests on the
  cluster.  Defaults to `bridged`.
- `['ganeti']['cluster']['nic']['link']` - Default NIC link for the guests on
  the cluster. Defaults to `br0`.
- `['ganeti']['cluster']['extra-opts']` - Arbitrary list of commands to send to
  the `gnt-cluster init` prompt outside of options already sent from the other
  attributes. Defaults to `nil`.

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

* Add Debian 7 support

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Oregon State University (<chef@osuosl.org>)
