#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::atom' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'obtains the atom installer' do
      expect(chef_run).to create_remote_file(File.join(Chef::Config[:file_cache_path], 'AtomSetup.exe')).with(
        source: 'https://atom.io/download/windows',
        backup: false
      )
    end

    it 'installs atom' do
      expect(chef_run).to install_windows_package('Atom').with(
        source: File.join(Chef::Config[:file_cache_path], 'AtomSetup.exe'),
        installer_type: :custom,
        options: '/silent'
      )
    end
  end

  context 'When all attributes are default, on mac_os_x' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.10') do |node|
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs homebrew cask for atom' do
      expect(chef_run).to install_cask('atom')
    end
  end

  context 'When all attributes are default, on ubuntu' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'adds atom ppa' do
      expect(chef_run).to add_apt_repository('atom-ppa').with(
        uri: 'http://ppa.launchpad.net/webupd8team/atom/ubuntu',
        distribution: 'trusty',
        components: ['main'],
        keyserver: 'keyserver.ubuntu.com',
        key: 'EEA14886'
      )
    end

    it 'installs atom' do
      expect(chef_run).to install_apt_package('atom')
    end
  end

  context 'When all attributes are default, on centos' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'downloads the atom rpm' do
      expect(chef_run).to create_remote_file('/tmp/atom.rpm').with(
        source: 'https://github.com/atom/atom/releases/download/v1.1.0/atom.x86_64.rpm'
      )
    end

    it 'installs redhat-lsb-core' do
      expect(chef_run).to install_yum_package('redhat-lsb-core')
    end

    it 'installs atom' do
      expect(chef_run).to install_rpm_package('atom.rpm')
    end
  end
end
