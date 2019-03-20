case node['platform_family']
when 'mac_os_x'
  homebrew_package 'tmux'
when 'debian'
  apt_package 'tmux'
when 'rhel'
  yum_package 'tmux'
end
