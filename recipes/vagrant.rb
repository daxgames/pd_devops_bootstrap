case node['platform_family']
when 'windows'
  chocolatey 'vagrant'
when 'mac_os_x'
  homebrew_cask 'vagrant'
when 'debian'
  apt_package 'vagrant'
else
  bash 'Download vagrant rpm' do
    code "curl -k https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.rpm > /tmp/vagrant.rpm"
    not_if { ::File.exists?('/tmp/vagrant.rpm') }
  end

  rpm_package 'vagrant.rpm' do
    source '/tmp/vagrant.rpm'
  end
end
