require 'digest'

# rapi_users expects h to be a Hash that looks like:
# h['username'] = {
#   'password' => 'secret',
#   'write' => true # or false
def rapi_users(h)
  rapi_users = []
  h.reject {|k,v| k == 'id' }.each_pair do |username,opts|
    md5 =  username + ":Ganeti Remote API:" + opts['password']
    md5 = Digest::MD5.new().update(md5).hexdigest
    rapi_users << "#{username} {HA1}#{md5} #{opts['write'] ? "write" : ""}"
  end
  return rapi_users.join("\n")
end
