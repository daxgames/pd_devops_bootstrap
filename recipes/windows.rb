include_recipe 'chocolatey_package'

# install chefdk
# Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, $chefDkSource

powershell_script "choco feature enable -n allowEmptyChecksums" do
 code <<-EOH
   choco feature enable -n allowEmptyChecksums
 EOH
end

powershell_script 'Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All' do
  code <<-EOH
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
  EOH
end

packages = node['packages']
  include_recipe "#{cookbook_name}::#{pkg}" if install
end

powershell_script "choco feature disable -n allowEmptyChecksums" do
  code <<-EOH
    choco feature disable -n allowEmptyChecksums
  EOH
end

include_recipe "#{cookbook_name}::powershell_profile"
