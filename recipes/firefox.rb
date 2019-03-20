case node['platform_family']
when 'windows'
  chocolatey 'firefox'
when 'mac_os_x'
  homebrew_cask 'firefox'
when 'debian'
  apt_package 'firefox'
when 'rhel'
  yum_package 'firefox'
end
