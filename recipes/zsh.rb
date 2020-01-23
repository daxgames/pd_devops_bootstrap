case node['platform_family']
when 'mac_os_x'
  homebrew_package 'zsh' do
    not_if { Dir::exists("#{ENV['home']}/.oh_my_zsh")}
  end
when 'debian'
  apt_package 'zsh'
else
  yum_package 'zsh'
end

execute 'install oh-my-zsh' do
  command 'sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"'
end
