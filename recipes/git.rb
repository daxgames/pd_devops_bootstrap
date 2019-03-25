case node['platform_family']
when 'windows'
  git_client 'Git version' do
    windows_package_version '2.21.0'
    windows_package_url 'https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/Git-2.21.0-64-bit.exe'
    windows_package_checksum 'c7792387ebd69b3e11b7cc7b92c743f75c180275fa0ce9c7f0c5c7e44e470f80'
  end

  chocolatey_package 'git-credential-winstore'
  chocolatey_package 'poshgit'
when 'mac_os_x'
  homebrew_package 'git'
when 'debian'
  apt_package 'git'
else
  yum_package 'git'
end
