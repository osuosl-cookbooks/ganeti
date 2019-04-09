require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'ganeti' }

CENTOS_6 = {
  platform: 'centos',
  version: '6.9',
}.freeze

CENTOS_7 = {
  platform: 'centos',
  version: '7.4.1708',
}.freeze

UBUNTU_14_04 = {
  platform: 'ubuntu',
  version: '14.04',
}.freeze

ALL_PLATFORMS = [
  CENTOS_6,
  CENTOS_7,
  UBUNTU_14_04,
].freeze

shared_context 'common_stubs' do
  before do
    stub_command('/sbin/lvm dumpconfig global/use_lvmetad | grep use_lvmetad=1')
  end
end

RSpec.configure do |config|
  config.log_level = :fatal
end
