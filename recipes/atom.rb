case node['platform_family']
when 'windows'
  chocolatey_package "dotnet4.5.2"
  atom_setup = File.join(Chef::Config[:file_cache_path], 'AtomSetup.exe')

  remote_file atom_setup do
    source node['atom']['windows']['source_url']
    backup false
  end

  windows_package 'Atom' do
    source atom_setup
    installer_type :custom
    options '/silent'
  end
when 'mac_os_x'
  homebrew_cask 'atom'
when 'debian'
  include_recipe 'apt'
  apt_repository 'atom-ppa' do
    uri 'http://ppa.launchpad.net/webupd8team/atom/ubuntu'
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key 'EEA14886'
  end

  apt_package 'atom'
when 'rhel'
  remote_file '/tmp/atom.rpm' do
    source node['atom']['centos_rhel']['source_url']
  end

  yum_package 'redhat-lsb-core' do
    install [:install, :lock]
    options '--exclude=stub-redhat-lsb-core-only-for-ceph-2015.1-1.atomic.el7.noarch'
  end

  yum_package 'libXScrnSaver'

  rpm_package 'atom.rpm' do
    source '/tmp/atom.rpm'
  end
end
