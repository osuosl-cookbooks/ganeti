require_relative '../../spec_helper'

describe 'ganeti::_kvm' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(p).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      case p
      when CENTOS_6, CENTOS_7
        %w(qemu-kvm qemu-kvm-tools).each do |pkg|
          it do
            expect(chef_run).to install_package(pkg)
          end
        end
        it do
          expect(chef_run).to load_kernel_module('kvm')
        end
      when UBUNTU_12_04, UBUNTU_14_04
        it do
          expect(chef_run).to install_package('qemu-kvm')
        end
        it do
          expect(chef_run).to_not load_kernel_module('kvm')
        end
      end
    end
  end
end
