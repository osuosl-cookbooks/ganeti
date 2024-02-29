require_relative '../../spec_helper'

describe 'ganeti-test::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(ganeti_initialize))
        ).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it do
        is_expected.to run_execute('ganeti-initialize').with(
          creates: '/var/lib/ganeti/config.data',
          command: <<~EOC
            /usr/sbin/gnt-cluster init \
              --enabled-disk-templates diskless \
              --master-netdev=eth1 \
              --enabled-hypervisors=fake \
              -N mode=routed,link=100 \
               \
              ganeti.example.com
          EOC
        )
      end
    end
  end
end
