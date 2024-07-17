# ganeti-cookbook

This cookbook is designed to install Ganeti.

## Supported Platforms

* RHEL 8

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
