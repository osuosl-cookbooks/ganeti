module Ganeti
  module Cookbook
    module Helpers
      require 'digest'
      require 'json'

      private

      def ganeti_kvm_packages
        %w(qemu-kvm)
      end

      def ganeti_drbd_packages
        %w(drbd84-utils kmod-drbd84)
      end

      def ganeti_services
        default_services =
          %w(
            ganeti.target
            ganeti-confd.service
            ganeti-luxid.service
            ganeti-mond.service
            ganeti-noded.service
            ganeti-rapi.service
            ganeti-wconfd.service
          )
        if ganeti_kvm_enabled?
          default_services << 'ganeti-kvmd.service'
        end
        default_services
      end

      def gpgkey
        case node['platform_version'].to_i
        when 8
          'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl'
        when 9
          'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024'
        when 10
          'https://ftp.osuosl.org/pub/osl/repos/yum/RPM-GPG-KEY-osuosl-2024'
        end
      end

      # rapi_users expects h to be a Hash that looks like:
      # h['username'] = {
      #   'password' => 'secret',
      #   'write' => true # or false
      def rapi_users(h)
        rapi_users = []
        h.reject { |k| k == 'id' }.each_pair do |username, opts|
          rapi_user =  "#{username}:Ganeti Remote API:#{opts['password']}"
          md5 = Digest::MD5.new.update(rapi_user).hexdigest
          rapi_users << "#{username} {HA1}#{md5} #{opts['write'] ? 'write' : ''}".strip
        end
        rapi_users
      end

      def ganeti_config
        begin
          JSON.parse(File.read('/var/lib/ganeti/config.data'))
        rescue
          {}
        end
      end

      def safe_dig(hash, *keys)
        keys.reduce(hash) do |acc, key|
          acc.is_a?(Hash) ? acc[key] : nil
        end
      end

      def ganeti_kvm_enabled?
        enabled_hypervisors = safe_dig(ganeti_config, 'cluster', 'enabled_hypervisors')
        if enabled_hypervisors
          enabled_hypervisors.include?('kvm')
        else
          false
        end
      end
    end
  end
end

Chef::DSL::Recipe.include Ganeti::Cookbook::Helpers
Chef::Resource.include Ganeti::Cookbook::Helpers
