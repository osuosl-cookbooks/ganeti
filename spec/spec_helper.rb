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

RSpec.configure do |config|
  config.log_level = :warn
end
