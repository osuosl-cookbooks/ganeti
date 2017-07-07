require_relative '../../spec_helper'

describe 'ganeti::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      lsb_codename = ''
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p) do |node|
          lsb_codename = node['lsb']['codename']
        end.converge(described_recipe)
      end
      include_context 'common_stubs'
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      %w(lvm modules).each do |r|
        it do
          expect(chef_run).to include_recipe(r)
        end
      end
      %w(/root/.ssh /var/lib/ganeti/rapi).each do |d|
        it do
          expect(chef_run).to create_directory(d)
            .with(
              owner: 'root',
              group: 'root',
              mode: 0750,
              recursive: true
            )
        end
      end
      it do
        expect(chef_run).to_not run_execute('ganeti-initialize')
      end
      context 'master' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.set['ganeti']['master-node'] = true
          end.converge(described_recipe)
        end
        it do
          expect(chef_run).to run_execute('ganeti-initialize')
            .with(
              command: '/usr/sbin/gnt-cluster init --enabled-disk-templates=plain,drbd --master-netdev=br0 ' \
                       '--enabled-hypervisors=kvm -N mode=bridged,link=br0  ',
              creates: '/var/lib/ganeti/config.data'
            )
        end
      end
      it do
        expect(chef_run).to enable_service('ganeti').with(supports: { status: true, restart: true })
      end
      it do
        expect(chef_run).to start_service('ganeti').with(supports: { status: true, restart: true })
      end
      it do
        expect(chef_run).to disable_service('drbd')
      end
      it do
        expect(chef_run).to stop_service('drbd')
      end
      it do
        expect(chef_run).to create_cookbook_file('/etc/cron.d/ganeti')
          .with(
            source: 'ganeti-cron',
            owner: 'root',
            group: 'root',
            mode: '0644'
          )
      end
      it do
        expect(chef_run).to create_cookbook_file('/etc/lvm/lvm.conf')
          .with(
            source: 'lvm.conf',
            owner: 'root',
            group: 'root',
            mode: '0644'
          )
      end
      case p
      when CENTOS_6, CENTOS_7
        %w(yum-epel yum-elrepo).each do |r|
          it do
            expect(chef_run).to include_recipe(r)
          end
        end
        it do
          expect(chef_run).to install_package('ganeti').with(version: nil)
        end
        it do
          expect(chef_run).to add_yum_repository('ganeti')
            .with(
              repositoryid: 'ganeti',
              description: 'Integ Ganeti Packages $releasever - $basearch',
              url: 'http://jfut.integ.jp/linux/ganeti/$releasever/$basearch',
              gpgcheck: false,
              gpgkey: nil
            )
        end
        case p
        when CENTOS_6
          %w(qemu-kvm qemu-kvm-tools drbd83-utils kmod-drbd83).each do |pkg|
            it do
              expect(chef_run).to install_package(pkg)
            end
          end
        when CENTOS_7
          %w(qemu-kvm qemu-kvm-tools drbd84-utils kmod-drbd84).each do |pkg|
            it do
              expect(chef_run).to install_package(pkg)
            end
          end
        end
      when UBUNTU_12_04, UBUNTU_14_04
        it do
          expect(chef_run).to include_recipe('apt')
        end
        it do
          expect(chef_run).to add_apt_repository('ganeti')
            .with(
              uri: 'ppa:pkg-ganeti-devel/lts',
              distribution: lsb_codename,
              components: %w(main),
              keyserver: 'keyserver.ubuntu.com',
              key: '38520275'
            )
        end
        %w(qemu-kvm drbd8-utils).each do |pkg|
          it do
            expect(chef_run).to install_package(pkg)
          end
        end
        it do
          expect(chef_run).to install_package('ganeti2').with(version: nil)
        end
      end
    end
  end
end
