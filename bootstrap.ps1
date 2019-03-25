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
$proxyHost = 'htttp-proxy.bedbath.com'
$proxyPort = '8080'

$proxyHost = '192.168.20.155'
$proxyPort = '3128'

# Set Proxy for this session
if ( ! ( test-path env:http_proxy ) ) {
  write-host "Setting http_proxy=http://${proxyHost}:${proxyPort}"
  $env:http_proxy="http://${proxyHost}:${proxyPort}"
}

if ( ! ( test-path env:https_proxy ) ) {
  write-host "Setting https_proxy=http://${proxyHost}:${proxyPort}"
  $env:https_proxy="http://${proxyHost}:${proxyPort}"
}

if ( ! ( test-path env:no_proxy ) ) {
  write-host "Setting no_proxy=127.0.0.1,localhost,github.bedbath.com"
  $env:no_proxy = "127.0.0.1,localhost,github.bedbath.com"
} elseif ( ! ( $env:no_proxy -match "github.bedbath.com" ) ) {
  write-host "Setting no_proxy=$env:no_proxy,github.bedbath.com"
  $env:no_proxy += ",github.bedbath.com"
}

$Wcl=New-Object System.Net.WebClient
$Wcl.proxy = (new-object System.Net.WebProxy($env:http_proxy))
$Wcl.proxy.BypassList = (($env:no_proxy).split(','))

# write-host $("Please enter credentials for " + $env:http_proxy)
# $Creds=Get-Credential
# $Wcl.Proxy.Credentials=$Creds

# dir env:*_proxy

$bootstrapCookbook = 'pd_devops_bootstrap'

if ($args[0]) {
  $bootstrapCookbook = $args[0]
}

if ($args[1]) {
  $privateSource = "source '$args[1]'"
}

$chefWorkstationSource = 'https://packages.chef.io/files/stable/chef-workstation/0.2.48/windows/2016/chef-workstation-0.2.48-1-x64.msi'
$portableGitSource = 'https://github.com/git-for-windows/git/releases/download/v2.21.0.windows.1/PortableGit-2.21.0-64-bit.7z.exe'

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

1. Install the latest Chef Workstation package.
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

Set-Location $userChefDir

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

if ( -not $(test-path c:\opscode\chef-workstation) ) {
  write-host Please wait, downloading $chefWorkstationSource to chef.msi...
  $Wcl.DownloadFile($chefWorkstationSource, "${userChefDir}\chef.msi")

  if (test-path 'chef.msi') {
    # Install chef-workstation .msi package from Chef
    if ( ! ( get-command chef -erroraction silentlycontinue ) ) {
      Write-Host 'Installing Chef Workstation...'
      Start-Process -Wait -FilePath msiexec.exe -ArgumentList /qb, /i, "${userChefDir}\chef.msi" -verbose
    }

  } else {
    write-host Downloading Chef Workstation failed!
  }
} else {
  write-host 'Chef Workstation is already installed!'
}

# Add chef-workstation to the path
if ( ! ( $env:path -match "C:\\opscode\\chef-workstation\\bin" ) ) {
  $env:Path += ";C:\opscode\chef-workstation\bin"
  del "${userChefDir}\chef.msi"
}

# Install Portable Git
if (! ( get-command git -erroraction silentlycontinue )) {
  if ( ! ( test-path "$userChefDir\git_portable.exe" ) ) {
    Write-Host Downloading $portableGitSource to git_portable.exe...
    # iwr $portableGitSource -outfile git_portable.exe
    $Wcl.DownloadFile($portableGitSource, "${userChefDir}\git_portable.exe")
  }

  if ( ! ( test-path "$portableGitPath\bin\git.exe" ) ) {
    Write-Host 'Installing Git Portable...'
    Start-Process -filepath "${userChefDir}\git_portable.exe" -wait -argumentlist "-y -gm2 --InstallPath=`"$portableGitPath`""
  }
} else {
  write-host 'Git is already installed!'
}


if ( ! ( get-command git -erroraction silentlycontinue ) ) {
  $env:Path += ";$portableGitPath\bin"
  del "${userChefDir}\git_portable.exe"
}

write-host $env:path

# Install the bootstrap cookbooks using Berkshelf
berks vendor -c $berksconfPath

set-executionpolicy bypass

# Install Chocolatey
if ( ! ( get-command choco -erroraction silentlycontinue ) ) {
  Write-Host 'Installing Chocolatey...'
  # iwr https://chocolatey.org/install.ps1 | iex
  $Wcl.DownloadFile('https://chocolatey.org/install.ps1', "${userChefDir}\install.ps1")
}

write-host "================================================"

iex "${userChefDir}\install.ps1"

write-host "================================================"

# del "${userChefDir}\install.ps1"

write-host "choco feature enable -n allowEmptyChecksums"
choco feature enable -n allowEmptyChecksums

# run chef-client (installed by Chef Workstation) to bootstrap this machine
$run_list = "$env:PD_DEVOPS_BOOTSTRAP_SELECTIONS"
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
