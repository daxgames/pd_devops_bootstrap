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
    install['cmder']         = true
    install['gitextensions'] = true
    install['kdiff3']        = true
    install['opera']         = true
    install['sococo']        = true
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
default['atom']['centos_rhel']['source_url']  = 'https://github.com/atom/atom/releases/download/v1.36.0-beta2/atom.x86_64.rpm'
default['opera']['centos_rhel']['source_url'] = 'http://get.geo.opera.com/pub/opera/desktop/58.0.3135.79/linux/opera-stable_58.0.3135.79_amd64.rpm'
default['sococo']['windows']['source_url']    = 'https://s.sococo.com/rs/client/mac/12-09-2019-SococoProd.exe'
default['sococo']['mac_os_x']['source_url']   = 'https://s.sococo.com/rs/client/mac/12-09-2019-SococoProd.dmg'

default['pd_devops_bootstrap']['proxy']['http']           = ENV['http_proxy']
default['pd_devops_bootstrap']['proxy']['https']          = ENV['https_proxy']
default['pd_devops_bootstrap']['proxy']['no_proxy']       = ENV['no_proxy']
default['pd_devops_bootstrap']['powershell']['configure'] = true
