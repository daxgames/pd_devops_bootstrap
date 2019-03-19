#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::docker' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'does not converge successfully' do
      expect { chef_run }.to raise_error
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

    it 'installs docker' do
      expect(chef_run).to install_cask('dockertoolbox')
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

    it 'installs docker' do
      expect(chef_run).to install_apt_package('docker.io')
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

    it 'adds the docker repo' do
      expect(chef_run).to create_yum_repository('docker').with(
        baseurl: 'https://yum.dockerproject.org/repo/main/centos/7',
        gpgkey: 'https://yum.dockerproject.org/gpg',
        enabled: true
      )
    end

    it 'installs docker' do
      expect(chef_run).to install_yum_package('docker-engine')
    end
  end
end
