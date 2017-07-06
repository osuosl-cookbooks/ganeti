require_relative '../../spec_helper'

describe 'ganeti-test::instance_image_subnet' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      subnets_path = '/etc/ganeti/instance-image/networks/subnets/'
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(instance_image_subnet))
        ).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_template(::File.join(subnets_path, 'vlan100'))
          .with(netmask: '255.255.255.0', gateway: '10.0.0.1')
      end
      it do
        expect(chef_run).to delete_file(::File.join(subnets_path, 'vlan101'))
      end
      [
        /^NETMASK="255.255.255.0"$/,
        /^GATEWAY="10.0.0.1"$/
      ].each do |line|
        it do
          expect(chef_run).to render_file(::File.join(subnets_path, 'vlan100')).with_content(line)
        end
      end
      it do
        expect(chef_run).to create_instance_image_subnet('vlan100')
          .with(netmask: '255.255.255.0', gateway: '10.0.0.1')
      end
      it do
        expect(chef_run).to delete_instance_image_subnet('vlan101')
      end
    end
  end
end
