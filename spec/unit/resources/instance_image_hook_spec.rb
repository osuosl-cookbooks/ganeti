require_relative '../../spec_helper'

describe 'ganeti-test::instance_image_hook' do
  ALL_PLATFORMS.each do |p|
    context "#{p[:platform]} #{p[:version]}" do
      cached(:chef_run) do
        ChefSpec::SoloRunner.new(
          p.dup.merge(step_into: %w(instance_image_hook))
        ).converge(described_recipe)
      end
      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end
      hooks_dir = '/etc/ganeti/instance-image/hooks'
      %w(create disable).each do |h|
        it do
          expect(chef_run).to create_cookbook_file(::File.join(hooks_dir, h)).with(source: h)
        end
      end
      %w(create grub source).each do |h|
        it do
          expect(chef_run).to create_file(::File.join(hooks_dir, h)).with(mode: '755')
        end
      end
      %w(foo disable).each do |h|
        it do
          expect(chef_run).to create_file(::File.join(hooks_dir, h)).with(mode: '644')
        end
      end
      it do
        expect(chef_run).to delete_file(::File.join(hooks_dir, 'delete'))
      end
      it do
        expect(chef_run).to create_cookbook_file(::File.join(hooks_dir, 'source')).with(source: 'change-source')
      end
      it do
        expect(chef_run).to create_instance_image_hook('create')
      end
      it do
        expect(chef_run).to enable_instance_image_hook('grub')
      end
      it do
        expect(chef_run).to disable_instance_image_hook('foo')
      end
      it do
        expect(chef_run).to create_instance_image_hook('disable').with(enable: false)
      end
      it do
        expect(chef_run).to delete_instance_image_hook('delete')
      end
      it do
        expect(chef_run).to create_instance_image_hook('source').with(source: 'change-source')
      end
    end
  end
end
