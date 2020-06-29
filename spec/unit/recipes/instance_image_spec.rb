require_relative '../../spec_helper'

describe 'ganeti::instance_image' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      lsb_codename = ''
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          lsb_codename = node['lsb']['codename']
          node.normal['ganeti']['instance_image']['config_defaults'] = { arch: 'x86_64' }
        end.converge(described_recipe)
      end
      include_context 'common_stubs'
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to install_package('ganeti-instance-image')
      end
      %w(
        /etc/ganeti/instance-image/hooks
        /etc/ganeti/instance-image/variants
        /etc/ganeti/instance-image/networks/instances
        /etc/ganeti/instance-image/networks/subnets
      ).each do |d|
        it do
          expect(chef_run).to create_directory(d).with(recursive: true)
        end
      end
      it do
        expect(chef_run).to create_template('/etc/default/ganeti-instance-image')
          .with(
            source: 'defaults.sh.erb',
            variables: {
              params: {
                'arch' => 'x86_64',
              },
            }
          )
      end
      it do
        expect(chef_run).to create_template('/etc/ganeti/instance-image/variants.list')
          .with(
            source: 'variants.list.erb',
            variables: {
              variants: %w(default),
            }
          )
      end
      [
        /^ARCH="x86_64"$/,
      ].each do |line|
        it do
          expect(chef_run).to render_file('/etc/default/ganeti-instance-image').with_content(line)
        end
      end
      [
        /^default$/,
      ].each do |line|
        it do
          expect(chef_run).to render_file('/etc/ganeti/instance-image/variants.list').with_content(line)
        end
      end
    end
  end
end
