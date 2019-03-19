case node['platform_family']
when 'debian'
  apt_package 'emacs24'
when 'rhel'
  yum_package 'emacs'
end
