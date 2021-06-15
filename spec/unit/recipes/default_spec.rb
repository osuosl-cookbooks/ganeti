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
      before do
        allow(File).to receive(:exist?).and_call_original
      end
      include_context 'common_stubs'
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it { expect(chef_run).to install_package('lvm2') }

      it do
        expect(chef_run).to create_directory('/root/.ssh').with(
          owner: 'root',
          group: 'root',
          mode: '700',
          recursive: true
        )
      end

      it do
        expect(chef_run).to create_directory('/var/lib/ganeti/rapi').with(
          owner: 'root',
          group: 'root',
          mode: '750',
          recursive: true
        )
      end

      it { expect(chef_run).to_not run_execute('ganeti-initialize') }

      context 'master' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.normal['ganeti']['master-node'] = true
          end.converge(described_recipe)
        end

        it do
          expect(chef_run).to run_execute('ganeti-initialize').with(
            command: '/usr/sbin/gnt-cluster init --enabled-disk-templates=plain,drbd --master-netdev=br0 --enabled-hypervisors=kvm -N mode=bridged,link=br0 ',
            creates: '/var/lib/ganeti/config.data'
          )
        end
      end

      context 'master on < ganeti-2.9.0' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.normal['ganeti']['master-node'] = true
            node.normal['ganeti']['version'] = '2.6.0'
          end.converge(described_recipe)
        end

        it do
          expect(chef_run).to run_execute('ganeti-initialize').with(
            command: '/usr/sbin/gnt-cluster init --master-netdev=br0 --enabled-hypervisors=kvm -N mode=bridged,link=br0 ',
            creates: '/var/lib/ganeti/config.data'
          )
        end
      end

      context 'master on >= ganeti-2.9.0' do
        cached(:chef_run) do
          ChefSpec::SoloRunner.new(p) do |node|
            node.normal['ganeti']['master-node'] = true
            node.normal['ganeti']['version'] = '2.15.0'
          end.converge(described_recipe)
        end

        it do
          expect(chef_run).to run_execute('ganeti-initialize').with(
            command: '/usr/sbin/gnt-cluster init --enabled-disk-templates=plain,drbd --master-netdev=br0 --enabled-hypervisors=kvm -N mode=bridged,link=br0 ',
            creates: '/var/lib/ganeti/config.data'
          )
        end
      end

      it do
        expect(chef_run).to enable_service('ganeti').with(
          service_name: 'ganeti.target',
          supports: { status: true, restart: true }
        )
      end
      it do
        expect(chef_run).to start_service('ganeti').with(
          service_name: 'ganeti.target',
          supports: { status: true, restart: true }
        )
      end

      %w(
        ganeti-confd
        ganeti-kvmd
        ganeti-luxid
        ganeti-noded
        ganeti-rapi
        ganeti-wconfd
      ).each do |ganeti_service|
        it do
          expect(chef_run).to enable_service(ganeti_service).with(supports: { status: true, restart: true })
        end
        it do
          expect(chef_run).to_not start_service(ganeti_service).with(supports: { status: true, restart: true })
        end
      end

      it do
        expect(chef_run).to create_cookbook_file('/etc/lvm/lvm.conf').with(
          source: 'lvm.conf',
          owner: 'root',
          group: 'root',
          mode: '0644'
        )
      end

      case p
      when CENTOS_7
        it do
          expect(chef_run).to include_recipe('yum-epel')
        end
        it do
          expect(chef_run).to install_package('ganeti').with(version: nil)
        end
        it do
          expect(chef_run).to create_yum_repository('ganeti').with(
            repositoryid: 'ganeti',
            description: 'Integ Ganeti Packages $releasever - $basearch',
            url: 'http://jfut.integ.jp/linux/ganeti/$releasever/$basearch',
            gpgcheck: false,
            gpgkey: nil
          )
        end
      end
    end
  end
end
