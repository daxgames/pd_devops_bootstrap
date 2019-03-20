include_recipe 'chocolatey'

# install chefdk
# Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, $chefDkSource

powershell_script "choco feature enable -n allowEmptyChecksums" do
 code <<-EOH
   powershell "choco feature enable -n allowEmptyChecksums"
 EOH
end

packages = node['packages']
  include_recipe "#{cookbook_name}::#{pkg}" if install
end

powershell_script "choco feature disable -n allowEmptyChecksums" do
  code <<-EOH
    powershell "choco feature disable -n allowEmptyChecksums"
  EOH
end

include_recipe "#{cookbook_name}::powershell_profile"
