packages = node['packages']

yum_package 'epel-release'
packages.each do |pkg, install|
  include_recipe "#{cookbook_name}::#{pkg}" if install
end
