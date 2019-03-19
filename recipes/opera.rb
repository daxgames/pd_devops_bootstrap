case node['platform_family']
when 'windows'
  chocolatey 'opera'
when 'mac_os_x'
  homebrew_cask 'opera'
when 'debian'
  include_recipe 'apt'
  apt_repository 'opera' do
    uri 'http://deb.opera.com/opera-stable/'
    key 'http://deb.opera.com/archive.key'
    distribution node['lsb']['codename']
    components ['stable', 'non-free']
  end

  apt_package 'opera-stable'
else
  remote_file '/tmp/opera.rpm' do
    source 'http://get.geo.opera.com/pub/opera/linux/1216/opera-12.16-1860.x86_64.rpm'
  end

  rpm_package 'opera.rpm' do
    source '/tmp/opera.rpm'
  end
end
