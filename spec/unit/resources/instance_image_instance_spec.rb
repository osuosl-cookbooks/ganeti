require_relative '../../spec_helper'

describe 'ganeti-test::instance_image_instance' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      instances_path = '/etc/ganeti/instance-image/networks/instances/'
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(instance_image_instance))
        ).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_template(::File.join(instances_path, 'foo.example.org'))
          .with(address: '127.0.0.1', subnet: 'vlan100')
      end
      it do
        expect(chef_run).to delete_file(::File.join(instances_path, 'bar.example.org'))
      end
      [
        /^ADDRESS="127.0.0.1"$/,
        /^SUBNET="vlan100"$/
      ].each do |line|
        it do
          expect(chef_run).to render_file(::File.join(instances_path, 'foo.example.org')).with_content(line)
        end
      end
      it do
        expect(chef_run).to create_instance_image_instance('foo.example.org')
          .with(address: '127.0.0.1', subnet: 'vlan100')
      end
      it do
        expect(chef_run).to delete_instance_image_instance('bar.example.org')
      end
    end
  end
end
