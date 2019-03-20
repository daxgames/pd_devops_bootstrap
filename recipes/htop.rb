case node['platform_family']
when 'mac_os_x'
  homebrew_package 'htop'
when 'debian'
  apt_package 'htop'
when 'rhel'
  yum_package 'htop'
end
