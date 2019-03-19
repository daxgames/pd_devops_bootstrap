packages = node['packages']

packages.each do |pkg, install|
  include_recipe "#{cookbook_name}::#{pkg}" if install
end
