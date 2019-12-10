require_relative '../../spec_helper'

describe 'ganeti::_drbd' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      it do
        expect(chef_run).to disable_service('drbd')
      end
      case p
      when CENTOS_6, CENTOS_7
        it do
          expect(chef_run).to include_recipe('yum-elrepo')
        end
        it do
          expect(chef_run).to create_file('/etc/modprobe.d/options_drbd.conf')
            .with(
              content: 'options drbd minor_count=128 usermode_helper=/bin/true'
            )
        end
        it do
          expect(chef_run).to delete_file('/etc/modprobe.d/drbd.conf')
        end
        it do
          expect(chef_run).to install_kernel_module('drbd')
        end
        it do
          expect(chef_run).to load_kernel_module('drbd')
        end
        case p
        when CENTOS_6
          %w(drbd83-utils kmod-drbd83).each do |pkg|
            it do
              expect(chef_run).to install_package(pkg)
            end
          end
        when CENTOS_7
          %w(drbd84-utils kmod-drbd84).each do |pkg|
            it do
              expect(chef_run).to install_package(pkg)
            end
          end
        end
      end
    end
  end
end
