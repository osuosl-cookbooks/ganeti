require_relative '../../spec_helper'

describe 'ganeti-test::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(ganeti_install))
        ).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { is_expected.to include_recipe 'yum-epel' }
      it { is_expected.to include_recipe 'yum-elrepo' }

      it do
        is_expected.to create_yum_repository('ganeti').with(
          description: 'Integ Ganeti Packages $releasever - $basearch',
          url: 'https://jfut.integ.jp/linux/ganeti/$releasever/$basearch',
          gpgcheck: true,
          gpgkey: 'https://jfut.integ.jp/linux/ganeti/RPM-GPG-KEY-integ-ganeti'
        )
      end

      it { is_expected.to install_selinux_install 'ganeti' }
      it { is_expected.to set_selinux_boolean('nis_enabled').with(value: 'on') }
      it { is_expected.to set_selinux_boolean('domain_can_mmap_files').with(value: 'on') }
      it { is_expected.to set_selinux_boolean('use_virtualbox').with(value: 'on') }
      it { is_expected.to install_package 'qemu-kvm' }
      it { is_expected.to install_package 'lvm2' }
      it { is_expected.to install_package %w(drbd84-utils kmod-drbd84) }
      it { is_expected.to disable_service 'drbd' }

      it do
        is_expected.to install_kernel_module('drbd').with(
          options: [
            'minor_count=128',
            'usermode_helper=/bin/true',
          ]
        )
      end
      it { is_expected.to load_kernel_module 'drbd' }
      it { is_expected.to install_package('ganeti').with(version: nil) }

      it do
        is_expected.to create_directory('/root/.ssh').with(
          mode: '700',
          recursive: true
        )
      end

      it do
        is_expected.to create_directory('/var/lib/ganeti/rapi').with(
          owner: 'gnt-rapi',
          group: 'gnt-masterd',
          mode: '0750',
          recursive: true
        )
      end

      it do
        is_expected.to create_template('/var/lib/ganeti/rapi/users').with(
          owner: 'gnt-rapi',
          group: 'gnt-masterd',
          cookbook: 'ganeti',
          source: 'users.erb',
          mode: '0640',
          variables: {
            users: [
              'testuser1 {HA1}076301fd349711d64d87b03ed31c61bc',
              'testuser2 {HA1}7a65e9c1cbc199e849f67783a7c94c0c',
            ],
          }
        )
      end

      it do
        is_expected.to create_cookbook_file('/etc/lvm/lvmlocal.conf').with(
          cookbook: 'ganeti',
          source: 'lvmlocal.conf',
          mode: '0644'
        )
      end
    end
  end
end
