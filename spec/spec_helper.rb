require 'chefspec'
require 'chefspec/berkshelf'

CENTOS_7 = {
  platform: 'centos',
  version: '7',
}.freeze

ALMA_8 = {
  platform: 'almalinux',
  version: '8',
}.freeze

ALL_PLATFORMS = [
  CENTOS_7,
  ALMA_8,
].freeze

shared_context 'common_stubs' do
  before do
    stub_command('/sbin/lvm dumpconfig global/use_lvmetad | grep use_lvmetad=1')
  end
end

RSpec.configure do |config|
  config.log_level = :warn
end
