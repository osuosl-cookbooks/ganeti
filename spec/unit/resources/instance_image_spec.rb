require_relative '../../spec_helper'

describe 'ganeti-test::instance_image' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(ganeti_instance_image))
        ).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        is_expected.to create_yum_repository('ganeti-instance-image').with(
          baseurl: 'https://ftp.osuosl.org/pub/osl/ganeti-instance-image/yum/$basearch/$releasever',
          description: 'Ganeti Instance Image - $basearch',
          gpgcheck: true,
          gpgkey: 'https://ftp.osuosl.org/pub/osl/ganeti-instance-image/yum/repo.gpg'
        )
      end

      it { is_expected.to install_package 'ganeti-instance-image' }

      %w(
        /etc/ganeti/instance-image/hooks
        /etc/ganeti/instance-image/variants
        /etc/ganeti/instance-image/networks/instances
        /etc/ganeti/instance-image/networks/subnets
      ).each do |d|
        it { is_expected.to create_directory(d).with(recursive: true) }
      end

      it do
        is_expected.to create_template('/etc/default/ganeti-instance-image').with(
          cookbook: 'ganeti',
          source: 'defaults.sh.erb',
          variables: {
            params: {},
          }
        )
      end
      it do
        is_expected.to create_template('/etc/ganeti/instance-image/variants.list').with(
          cookbook: 'ganeti',
          source: 'variants.list.erb',
          variables: {
            variants: %w(default),
          }
        )
      end
    end
  end
end
