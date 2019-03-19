#
# Cookbook Name:: pd_devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pd_devops_bootstrap::opera' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs chrome' do
      expect(chef_run).to install_chocolate('opera')
    end
  end

  context 'When all attributes are default, on mac_os_x' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'mac_os_x', version: '10.10') do |node|
      end
      runner.converge(described_recipe)
    end

    before do
      stub_command("which git").and_return('/usr/local/bin/git')
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs chrome' do
      expect(chef_run).to install_cask('opera')
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

    it 'adds the opera repo' do
      expect(chef_run).to add_apt_repository('opera').with(
        uri: 'http://deb.opera.com/opera-stable/',
        key: 'http://deb.opera.com/archive.key',
        distribution: 'trusty',
        components: ['stable', 'non-free']
      )
    end

    it 'installs opera-stable' do
      expect(chef_run).to install_apt_package('opera-stable')
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

    it 'downloads the opera rpm' do
      expect(chef_run).to create_remote_file('/tmp/opera.rpm').with(
        source: 'http://get.geo.opera.com/pub/opera/linux/1216/opera-12.16-1860.x86_64.rpm'
      )
    end

    it 'installs opera' do
      expect(chef_run).to install_rpm_package('opera.rpm').with(
        source: '/tmp/opera.rpm'
      )
    end
  end
end
