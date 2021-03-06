case node['platform_family']
when 'windows'
  chocolatey_package 'virtualbox' do
    options '--version 6.0.16'
  end
when 'mac_os_x'
  homebrew_cask 'virtualbox' do
    options '--version 0.6.16'
  end
when 'debian'
  include_recipe 'apt'
  apt_package 'virtualbox'
when 'rhel'
  yum_repository 'virtualbox' do
  baseurl "http://download.virtualbox.org/virtualbox/rpm/el/#{node['platform_version'].split('.')[0]}/$basearch"
    gpgkey 'https://www.virtualbox.org/download/oracle_vbox.asc'
    gpgcheck false
    enabled true
  end

  # bash 'yum update' do
  #   code "yum update"
  # end

  %w(binutils qt gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms).each do |package|
    yum_package package
  end

  yum_package 'VirtualBox-6.0'
end
