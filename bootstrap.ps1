# Copyright 2015 Nordstrom, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$bootstrapCookbook = 'pd_devops_bootstrap'

if ($args[0]) {
  $bootstrapCookbook = $args[0]
}

if ($args[1]) {
  $privateSource = "source '$args[1]'"
}

$chefDkSource = 'https://www.chef.io/chef/download-chefdk?p=windows&pv=2008r2&m=x86_64&v=latest'
$portableGitSource = "https://github.com/git-for-windows/git/releases/download/v2.11.0.windows.1/PortableGit-2.11.0-32-bit.7z.exe"

$userChefDir = Join-Path -path $env:USERPROFILE -childPath 'chef'
$berksfilePath = Join-Path -path $userChefDir -childPath 'Berksfile'
$berksconfPath = Join-Path -path $userChefDir -childPath 'config.json'
$chefConfigPath = Join-Path -path $userChefDir -childPath 'client.rb'
$portableGitPath = Join-Path -path $userChefDir -childPath 'PortableGit'


# Set HOME to be c:\users\<username> so cookbook gem installs are on the c:\
# drive
$env:HOME = $env:USERPROFILE

$berksfile = @"
source 'https://supermarket.chef.io'
$privateSource

cookbook '$bootstrapCookbook', git: 'https://github.bedbath.com/pipedream/pd_devops_bootstrap.git'
"@

$berksconfig = @"
{"ssl":{"verify": false }}
"@

$chefConfig = @"
cookbook_path File.join(Dir.pwd, 'berks-cookbooks')
node_path File.join(Dir.pwd, 'nodes')
"@

$introduction = @"

### This bootstrap script will:

1. Install the latest ChefDK package.
2. Create a `chef` directory in your user profile (home) directory.
3. Download the `chefdk_bootstrap` cookbook via Berkshelf
4. Run `chef-client` to install the rest of the tools you'll need.

"@

Clear-Host

Write-Host $introduction

# create the chef directory
if (!(Test-Path $userChefDir -pathType container)) {
  New-Item -ItemType 'directory' -path $userChefDir
}

# Write out a local Berksfile for Berkshelf to use
$berksfile | Out-File -FilePath $berksfilePath -Encoding ASCII

# Write out a local Berks config for Berkshelf to use
$berksconfig | Out-File -FilePath $berksconfPath -Encoding ASCII

# Write out minimal chef-client config file
$chefConfig | Out-File -FilePath $chefConfigPath -Encoding ASCII

# Set Proxy for this session
if ( ! ( test-path env:http_proxy ) ) {
  write-host "Setting http_proxy=http://10.41.161.24:3128"
  $env:http_proxy="http://10.41.161.24:3128"
}

if ( ! ( test-path env:https_proxy ) ) {
  write-host "Setting https_proxy=http://10.41.161.24:3128"
  $env:https_proxy="http://10.41.161.24:3128"
}

if ( ! ( test-path env:no_proxy ) ) {
  write-host "Setting no_proxy=127.0.0.1,localhost,github.bedbath.com"
  $env:no_proxy = "127.0.0.1,localhost,github.bedbath.com"
} elseif ( ! ( $env:no_proxy -match "github.bedbath.com" ) ) {
  write-host "Setting no_proxy=$env:no_proxy,github.bedbath.com"
  $env:no_proxy += ",github.bedbath.com"
}

# Install ChefDK .msi package from Chef
if ( ! ( get-command chef -erroraction silentlycontinue ) ) {
  Write-Host 'Installing ChefDK...'
  # if ( ! ( test-path "$userChefDir\ChefDK.msi" ) ) {
  #   iwr "$chefDkSource" -outfile "$userChefDir\ChefDK.msi"
  # }
  # Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, "$userChefDir\ChefDK.msi" -verbose

  Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, "$chefDkSource" -verbose  
}

# Add ChefDK to the path
if ( ! ( $env:path -match "C:\\opscode\\chefdk\\bin" ) ) {
  $env:Path += ";C:\opscode\chefdk\bin"
}

Set-Location $userChefDir

# Install Portable Git
if (! ( get-command git -erroraction silentlycontinue )) {
  if ( ! ( test-path "$userChefDir\git_portable.exe" ) ) {
    Write-Host 'Downloading Git Portable...'
    iwr $portableGitSource -outfile git_portable.exe
  }

  if ( ! ( test-path "$portableGitPath\bin\git.exe" ) ) {
    Write-Host 'Installing Git Portable...'
    Start-Process -filepath git_portable.exe -wait -argumentlist "-y -gm2 --InstallPath=`"$portableGitPath`""
  }

  if ( ! ( get-command git -erroraction silentlycontinue ) ) {
    $env:Path += ";$portableGitPath\bin"
  }
}

write-host $env:path

# Install the bootstrap cookbooks using Berkshelf
berks vendor -c $berksconfPath

set-executionpolicy bypass

# Install Chocolatey
if ( ! ( get-command choco -erroraction silentlycontinue ) ) {
  Write-Host 'Installing Chocolatey...'
  iwr https://chocolatey.org/install.ps1 | iex

}

write-host "choco feature enable -n allowEmptyChecksums"
choco feature enable -n allowEmptyChecksums

# run chef-client (installed by ChefDK) to bootstrap this machine
$run_list = "$env:GeDevopsBootstrapSelections"
chef-client -A -z -l error -c $chefConfigPath -o $run_list

write-host "choco feature disable -n allowEmptyChecksums"
choco feature disable -n allowEmptyChecksums

# Cleanup
# if (Test-Path $berksfilePath) {
#  Remove-Item $berksfilePath
# }

# if (Test-Path "$berksfilePath.lock") {
#   Remove-Item "$berksfilePath.lock"
# }

# if (Test-Path $chefConfigPath) {
#   Remove-Item $chefConfigPath
# }

# if (Test-Path nodes) {
#   Remove-Item -Recurse nodes
# }

# if (Test-Path berks-cookbooks) {
#   Remove-Item -Recurse berks-cookbooks
# }

# End message to indicate completion of setup
Write-Host "`n`nCongrats!!! Your workstation is now set up for Chef Development!"