# This isn't nessesary unless we are using chef 11 or less.
include_recipe 'homebrew'
include_recipe 'homebrew::cask'

packages = node['packages']

packages.each do |pkg, install|
  include_recipe "#{cookbook_name}::#{pkg}" if install
end
