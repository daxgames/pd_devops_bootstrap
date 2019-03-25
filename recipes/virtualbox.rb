case node['platform_family']
when 'windows'
  chocolatey_package 'virtualbox'
when 'mac_os_x'
  homebrew_cask 'virtualbox'
when 'debian'
  include_recipe 'apt'
  apt_package 'virtualbox'
when 'rhel'
  yum_repository 'virtualbox' do
    baseurl "http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch"
    gpgkey 'https://www.virtualbox.org/download/oracle_vbox.asc'
    gpgcheck false
    enabled true
  end

  bash 'yum update' do
    code "yum update"
  end

  %w(binutils qt gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms).each do |package|
    yum_package package
  end

  yum_package 'VirtualBox-6.0'
end
