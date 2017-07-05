require 'chefspec'
require 'chefspec/berkshelf'

ChefSpec::Coverage.start! { add_filter 'ganeti' }

CENTOS_6 = {
  platform: 'centos',
  version: '6.7'
}.freeze

UBUNTU_12_04 = {
  platform: 'ubuntu',
  version: '12.04'
}.freeze

UBUNTU_14_04 = {
  platform: 'ubuntu',
  version: '14.04'
}.freeze

ALL_PLATFORMS = [
  CENTOS_6,
  UBUNTU_12_04,
  UBUNTU_14_04
].freeze

RSpec.configure do |config|
  config.log_level = :fatal
end
