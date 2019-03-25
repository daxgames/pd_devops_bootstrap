case node['platform_family']
when 'windows'
  git_client 'Git version 2.11.0' do
    windows_package_version '2.11.0'
    windows_package_url 'https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/Git-2.11.0-64-bit.exe'
    windows_package_checksum 'fd1937ea8468461d35d9cabfcdd2daa3a74509dc9213c43c2b9615e8f0b85086'
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
