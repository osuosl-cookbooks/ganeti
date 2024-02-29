require_relative '../../spec_helper'

describe 'ganeti-test::default' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(ganeti_service))
        ).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      %w(
        ganeti.target
        ganeti-confd.service
        ganeti-kvmd.service
        ganeti-luxid.service
        ganeti-mond.service
        ganeti-noded.service
        ganeti-rapi.service
        ganeti-wconfd.service
      ).each do |s|
        it do
          is_expected.to enable_service(s).with(
            supports: {
              status: true,
              restart: true,
              reload: false,
            }
          )
        end
      end
    end
  end
end
