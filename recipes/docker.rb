case node['platform_family']
when 'windows'
  fail 'Need to find a way to install.'
when 'mac_os_x'
  homebrew_cask 'dockertoolbox'
when 'debian'
  apt_package 'docker.io'
when 'rhel'
  yum_repository 'docker' do
    baseurl 'https://yum.dockerproject.org/repo/main/centos/7'
    gpgkey 'https://yum.dockerproject.org/gpg'
    enabled true
  end

  yum_package 'docker-engine'
end
