require_relative '../../spec_helper'

describe 'ganeti-test::instance_image_variant' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(instance_image_variant))
        ).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to create_template('/etc/ganeti/instance-image/variants/centos-7.conf')
          .with(
            cookbook: 'ganeti',
            source: 'variants.sh.erb',
            variables: {
              arch: '',
              boot_size: '',
              cache_dir: '',
              cdinstall: '',
              customize_dir: '',
              filesystem: 'ext4',
              image_cleanup: '',
              image_debug: '',
              image_dir: '',
              image_name: 'centos-7.3',
              image_type: '',
              image_url: '',
              image_verify: '',
              kernel_args: '',
              nomount: '',
              overlay: '',
              swap: '',
              swap_size: ''
            }
          )
      end
      it do
        expect(chef_run).to create_template('/etc/ganeti/instance-image/variants/centos-6.conf')
          .with(
            cookbook: 'ganeti',
            source: 'variants.sh.erb',
            variables: {
              arch: 'x86_64',
              boot_size: '200',
              cache_dir: '/var/foo/bar',
              cdinstall: '',
              customize_dir: '/tmp/foo/bar',
              filesystem: 'ext4',
              image_cleanup: 'yes',
              image_debug: '1',
              image_dir: '',
              image_name: 'centos-6.9',
              image_type: 'tarball',
              image_url: 'http://ganeti.example.org',
              image_verify: 'no',
              kernel_args: 'console=ttyS0',
              nomount: 'yes',
              overlay: '/bar/foo',
              swap: 'no',
              swap_size: '1024'
            }
          )
      end
      [
        /^FILESYSTEM="ext4"$/,
        /^IMAGE_NAME="centos-7.3"$/
      ].each do |line|
        it do
          expect(chef_run).to render_file('/etc/ganeti/instance-image/variants/centos-7.conf').with_content(line)
        end
      end
      [
        /^ARCH="x86_64"$/,
        /^BOOT_SIZE="200"$/,
        %r{^CACHE_DIR="/var/foo/bar"$},
        %r{^CUSTOMIZE_DIR="/tmp/foo/bar"$},
        /^FILESYSTEM="ext4"$/,
        /^IMAGE_CLEANUP="yes"$/,
        /^IMAGE_DEBUG="1"$/,
        /^IMAGE_NAME="centos-6.9"$/,
        /^IMAGE_TYPE="tarball"$/,
        %r{^IMAGE_URL="http://ganeti.example.org"$},
        /^IMAGE_VERIFY="no"$/,
        /^KERNEL_ARGS="console=ttyS0"$/,
        /^NOMOUNT="yes"$/,
        /^SWAP="no"$/,
        /^SWAP_SIZE="1024"$/
      ].each do |line|
        it do
          expect(chef_run).to render_file('/etc/ganeti/instance-image/variants/centos-6.conf').with_content(line)
        end
      end
      it do
        expect(chef_run).to delete_file('/etc/ganeti/instance-image/variants/debian.conf')
      end
      it do
        expect(chef_run).to create_instance_image_variant('centos-7').with(image_name: 'centos-7.3', filesystem: 'ext4')
      end
      it do
        expect(chef_run).to create_instance_image_variant('centos-6').with(
          arch: 'x86_64',
          boot_size: '200',
          cache_dir: '/var/foo/bar',
          cdinstall: '',
          customize_dir: '/tmp/foo/bar',
          filesystem: 'ext4',
          image_cleanup: 'yes',
          image_debug: '1',
          image_dir: '',
          image_name: 'centos-6.9',
          image_type: 'tarball',
          image_url: 'http://ganeti.example.org',
          image_verify: 'no',
          kernel_args: 'console=ttyS0',
          nomount: 'yes',
          overlay: '/bar/foo',
          swap: 'no',
          swap_size: '1024'
        )
      end
      it do
        expect(chef_run).to delete_instance_image_variant('debian')
      end
    end
  end
end
