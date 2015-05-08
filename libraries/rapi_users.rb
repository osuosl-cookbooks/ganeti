require 'digest'

# rapi_users expects h to be a Hash that looks like:
# h['username'] = {
#   'password' => 'secret',
#   'write' => true # or false
def rapi_users(h)
  rapi_users = []
  h.reject { |k| k == 'id' }.each_pair do |username, opts|
    rapi_user =  "#{username}:Ganeti Remote API:#{opts['password']}"
    md5 = Digest::MD5.new.update(rapi_user).hexdigest
    rapi_users << "#{username} {HA1}#{md5} #{opts['write'] ? 'write' : ''}"
  end
  rapi_users.join("\n")
end
