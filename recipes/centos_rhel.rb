packages = node['packages']

yum_package 'epel-release'

remote_file '/tmp/epel.rpm' do
  source 'https://dl.fedoraproject.org/pub/epel/6/x86_64/Packages/e/epel-release-6-8.noarch.rpm'
  only_if {node['platform'] != 'fedora' && node['platform_version'] =~ /^6/}
end

remote_file '/tmp/epel.rpm' do
  source 'https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/e/epel-release-7-11.noarch.rpm'
  only_if {node['platform'] != 'fedora' && node['platform_version'] =~ /^7/}
end

yum_package 'epel-release' do
  source '/tmp/epel.rpm'
  only_if {File.exist('/tmp/epel.rpm')}
end

packages.each do |pkg, install|
  include_recipe "#{cookbook_name}::#{pkg}" if install
end
