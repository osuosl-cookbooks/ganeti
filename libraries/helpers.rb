module Ganeti
  module Cookbook
    module Helpers
      require 'digest'

      def ganeti_kvm_packages
        case node['platform_version'].to_i
        when 7
          %w(qemu-kvm qemu-kvm-tools)
        when 8
          %w(qemu-kvm)
        end
      end

      def ganeti_drbd_packages
        %w(drbd84-utils kmod-drbd84)
      end

      def ganeti_services
        %w(
          ganeti.target
          ganeti-confd.service
          ganeti-kvmd.service
          ganeti-luxid.service
          ganeti-mond.service
          ganeti-noded.service
          ganeti-rapi.service
          ganeti-wconfd.service
        )
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
    end
  end
end

Chef::DSL::Recipe.include Ganeti::Cookbook::Helpers
Chef::Resource.include Ganeti::Cookbook::Helpers
