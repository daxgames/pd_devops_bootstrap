# Must be set attributes, details are in the README
default['workstation']['user'] = 'lancelacoste'

# Homebrew
default['homebrew']['install_command'] = 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
default['homebrew']['owner']           = default['workstation']['user']

# What to install:
default['packages'].tap do |install|
  install['atom']       = true
  install['chrome']     = true
  install['firefox']    = true
  install['git']        = true
  install['vagrant']    = true
  install['virtualbox'] = true
  install['sublime']    = true
end

case node['platform_family']
when 'windows'
  default['packages'].tap do |install|
    #install['cmder']         = true
    #install['gitextensions'] = true
    #install['kdiff3']        = true
    #install['opera']         = true
    #install['sococo']        = true
  end
when 'mac_os_x'
  default['packages'].tap do |install|
    install['caffeine']  = true
    install['docker']    = true
    install['htop']      = true
    install['iterm2']    = true
    install['opera']     = true
    install['spectacle'] = true
    install['sococo']    = true
    install['squidman']  = true
    install['zsh']       = true
  end
when 'debian'
  default['packages'].tap do |install|
    install['docker'] = true
    install['emacs']  = true
    install['htop']   = true
    install['zsh']    = true
  end
when 'rhel'
  default['packages'].tap do |install|
    install['docker'] = true
    install['emacs']  = true
    install['htop']   = true
    install['zsh']    = true
  end
end

default['atom']['windows']['source_url']      = 'https://atom.io/download/windows'
default['atom']['centos_rhel']['source_url']  = 'https://github.com/atom/atom/releases/download/v1.12.9/atom.x86_64.rpm'
# default['opera']['centos_rhel']['source_url'] = 'http://get.geo.opera.com/pub/opera/linux/1216/opera-12.16-1860.x86_64.rpm'
default['opera']['centos_rhel']['source_url'] = 'http://download2.operacdn.com/pub/opera/desktop/42.0.2393.94/linux/opera-stable_42.0.2393.94_i386.rpm'
default['sococo']['windows']['source_url']    = 'https://s.sococo.com/rs/client/win64/Sococo-x64-0.5.0-12053.exe'

default['devops_bootstrap']['proxy']['http']           = ENV['http_proxy']
default['devops_bootstrap']['proxy']['https']          = ENV['https_proxy']
default['devops_bootstrap']['proxy']['no_proxy']       = ENV['no_proxy']
default['devops_bootstrap']['powershell']['configure'] = true
