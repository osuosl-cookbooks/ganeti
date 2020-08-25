instance_image_variant 'centos-7' do
  image_name 'centos-7.3'
  filesystem 'ext4'
end

instance_image_variant 'centos-6' do
  image_name 'centos-6.9'
  filesystem 'ext4'
  arch 'x86_64'
  boot_size '200'
  cache_dir '/var/foo/bar'
  customize_dir '/tmp/foo/bar'
  image_cleanup 'yes'
  image_debug '1'
  image_type 'tarball'
  image_url 'http://ganeti.example.org'
  image_verify 'no'
  kernel_args 'console=ttyS0'
  nomount 'yes'
  overlay '/bar/foo'
  swap 'no'
  swap_size '1024'
end

instance_image_variant 'debian' do
  image_name ''
  action :delete
end
