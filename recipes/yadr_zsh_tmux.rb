case node['platform_family']
when 'mac_os_x', 'rhel', 'debian'
  execute 'install yadr(zsh)' do
    command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/skwp/dotfiles/master/install.sh)"'
  end
end

