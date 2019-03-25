case node['platform_family']
when 'windows'
  chocolatey_package 'sublimetext2'
when 'mac_os_x'
  homebrew_cask 'sublime-text'
when 'debian'
  apt_repository 'sublime' do
    uri 'ppa:webupd8team/sublime-text-2'
    distribution node['lsb']['codename']
    components ['main']
  end

  apt_package 'sublime-text'
else
  bash 'install sublime' do
    code <<-EOH
cd ~
curl http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2 > sublime.tar.bz2
tar vxjf sublime.tar.bz2
mv 'Sublime Text 2' /opt/SublimeText2
ln -s /opt/SublimeText2/sublime_text /usr/bin/sublime
    EOH
    not_if { ::File.exists?('/usr/bin/sublime') }
  end
end
