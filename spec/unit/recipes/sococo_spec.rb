#
# Cookbook Name:: pd_devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pd_devops_bootstrap::sococo' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'obtains the sococo installer' do
      expect(chef_run).to create_remote_file(File.join(Chef::Config[:file_cache_path], 'SococoSetup.exe')).with(
        source: 'http://download.sococo.com/release/Sococo_3_5_17_14260.exe',
        backup: false
      )
    end

    it 'installs sococo' do
      expect(chef_run).to install_windows_package('Sococo').with(
        source: File.join(Chef::Config[:file_cache_path], 'SococoSetup.exe'),
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

    it 'installs sococo' do
      expect(chef_run).to install_cask('sococo')
    end
  end
end
