# ganeti-cookbook

Installs and configures [Ganeti](https://ganeti.org), optionally along with the
[ganeti-instance-image](https://github.com/osuosl/ganeti-instance-image) OS
provider.

## Supported Platforms

* AlmaLinux 8
* AlmaLinux 9
* AlmaLinux 10

## Requirements

* Chef/Cinc >= 17
* `selinux` >= 6.2.4
* `yum-elrepo` >= 3.0.0
* `yum-epel` >= 6.0.0

## Attributes

| Attribute | Type | Description | Default |
| --------- | ---- | ----------- | ------- |
| `['ganeti']['instance_image']['config_dir']` | String | Configuration directory for ganeti-instance-image. | `/etc/ganeti/instance-image` |

## Resources

### ganeti_install

Configures the repositories, installs Ganeti and its SELinux policy, and lays
down the RAPI user list.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `yum_baseurl` | String | Base URL for the Ganeti repository. | upstream integ repository |
| `yum_gpgkey` | String | GPG key for the Ganeti repository. | upstream key for the platform |
| `hypervisor` | String | Hypervisor to install packages for. Only `kvm` pulls in extra packages. | `kvm` |
| `kvm_packages` | Array | Packages installed when `hypervisor` is `kvm`. | `%w(qemu-kvm)` |
| `drbd` | true, false | Configure ELRepo, install the DRBD packages, and load the `drbd` kernel module. | `true` |
| `version` | String | Pin the `ganeti` package to a specific version. | latest |
| `rapi_users` | Hash | RAPI users, keyed by username, with `password` and `write` keys. Sensitive. | `{}` |
| `manage_repo` | true, false | Whether this resource configures the upstream Ganeti yum repository. | `true` |
| `manage_epel` | true, false | Whether this resource configures the EPEL repository. | `true` |
| `manage_elrepo` | true, false | Whether this resource configures the ELRepo repository, the source of the DRBD packages. | `true` |

```ruby
ganeti_install 'default' do
  rapi_users(
    someuser: {
      password: 'p4ssw0rd',
      write: true,
    }
  )
end
```

Set the `manage_*` properties to `false` on nodes where a wrapper cookbook
already manages those repositories:

```ruby
ganeti_install 'default' do
  manage_epel false
  manage_elrepo false
end
```

### ganeti_initialize

Runs `gnt-cluster init` once, guarded on `/var/lib/ganeti/config.data`. The
resource name is the cluster name.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `disk_templates` | Array | Enabled disk templates. | `%w(plain drbd)` |
| `enabled_hypervisors` | Array | Enabled hypervisors. | `%w(kvm)` |
| `extra_opts` | Array | Additional flags passed to `gnt-cluster init`. | `[]` |
| `master_netdev` | String | Master network device. Required. | |
| `nic_link` | String | Default NIC link. Required. | |
| `nic_mode` | String | Default NIC mode. | `bridged` |

### ganeti_service

Manages the full set of Ganeti services as a unit. Actions: `:start`, `:stop`,
`:restart`, `:reload`, `:enable`, `:disable`. `ganeti-kvmd.service` is included
only when the running cluster has KVM enabled.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `delay_start` | true, false | Delay `:start`, `:restart`, and `:reload` to the end of the run. | `true` |

### ganeti_instance_image

Configures the OSUOSL repository, installs `ganeti-instance-image`, and creates
its configuration tree.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `config_defaults` | Hash | Values rendered into `/etc/default/ganeti-instance-image`. | `{}` |
| `variants_list` | Array | Variants listed in `variants.list`. | `%w(default)` |
| `yum_baseurl` | String | Base URL for the OSUOSL repository. | OSUOSL mirror |
| `yum_gpgkey` | String | GPG key for the OSUOSL repository. | OSUOSL key for the platform |

### instance_image_variant

Manages a variant configuration file. Actions: `:create`, `:delete`. `image_name`
is required for `:create`; every other property is an optional string written
through to the variant file: `arch`, `boot_size`, `cache_dir`, `cdinstall`,
`customize_dir`, `filesystem`, `image_cleanup`, `image_debug`, `image_dir`,
`image_type`, `image_url`, `image_verify`, `kernel_args`, `nomount`, `overlay`,
`swap`, and `swap_size`.

```ruby
instance_image_variant 'centos-7' do
  image_name 'centos-7.3'
  filesystem 'ext4'
end
```

### instance_image_hook

Manages a hook in the instance-image hooks directory. Actions: `:create`,
`:delete`, `:enable`, `:disable`.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `enable` | true, false | Whether `:create` leaves the hook executable. | `true` |
| `source` | String | Cookbook file to deploy. | the resource name |

### instance_image_instance

Manages a per-instance network file. Actions: `:create`, `:delete`.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `address` | String | Instance address. Required for `:create`. | |
| `subnet` | String | Subnet name, matching an `instance_image_subnet`. Required for `:create`. | |

### instance_image_subnet

Manages a subnet file. Actions: `:create`, `:delete`.

| Property | Type | Description | Default |
| -------- | ---- | ----------- | ------- |
| `netmask` | String | Subnet netmask. Required for `:create`. | |
| `gateway` | String | Subnet gateway. Required for `:create`. | |

## Usage

```ruby
ganeti_install 'default'

ganeti_initialize 'ganeti.example.com' do
  disk_templates %w(plain)
  master_netdev 'eth0'
  enabled_hypervisors %w(kvm)
  nic_mode 'bridged'
  nic_link 'br0'
end

ganeti_service 'default' do
  action :enable
end
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (i.e. `add-new-recipe`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request

## License and Authors

Author:: Oregon State University (<chef@osuosl.org>)
