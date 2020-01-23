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
  sococo_setup = File.join(Chef::Config[:file_cache_path], 'SococoSetup.dmg')

  remote_file sococo_setup do
    source node['sococo']['mac_os_x']['source_url']
    backup false
  end

  execute "hdiutil attach #{sococo_setup}"

  bash "install sococo to ~/Applications" do
    code <<-EOH
      hdiutil attach #{sococo_setup}
      cd /Volumes/Sococo
      if [[ -d ${HOME}/Applications ]] ; then
        rm -Rf ${HOME}/Applications
      fi

      cp -Rp ./Sococo.app ~/Applications
      cd ${HOME}/Desktop
      hdiutil detach /Volumes/Sococo
    EOH
  end
end
