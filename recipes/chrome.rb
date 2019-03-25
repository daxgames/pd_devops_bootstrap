case node['platform_family']
when 'windows'
  chocolatey_package 'googlechrome'
when 'mac_os_x'
  homebrew_cask 'google-chrome'
when 'debian'
  apt_package 'chromium-browser'
when 'rhel'
  yum_repository 'google-chrome' do
    baseurl "http://dl.google.com/linux/chrome/rpm/stable/$basearch"
    # gpgkey 'https://dl-ssl.google.com/linux/linux_signing_key.pub'
    gpgcheck false
    enabled true
  end

  yum_package 'google-chrome-stable'
end
