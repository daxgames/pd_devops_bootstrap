case node['platform_family']
when 'windows'
  sococo_setup = File.join(Chef::Config[:file_cache_path], 'SococoSetup.exe')

  remote_file sococo_setup do
    source node['sococo']['windows']['source_url']
    backup false
  end

  windows_package 'Sococo' do
    source sococo_setup
    installer_type :custom
    options '/silent'
  end
when 'mac_os_x'
  homebrew_cask 'sococo'
end
