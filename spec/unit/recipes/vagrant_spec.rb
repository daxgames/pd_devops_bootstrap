#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::vagrant' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs vagrant' do
      expect(chef_run).to install_chocolate('vagrant')
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

    it 'installs vagrant' do
      expect(chef_run).to install_cask('vagrant')
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

    it 'installs vagrant' do
      expect(chef_run).to install_apt_package('vagrant')
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

    it 'Downloads the vagrant rpm' do
      expect(chef_run).to run_bash('Download vagrant rpm').with(
        code: "curl -k https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.rpm > /tmp/vagrant.rpm"
      )
    end

    it 'installs vagrant' do
      expect(chef_run).to install_rpm_package('vagrant.rpm').with(
        source: '/tmp/vagrant.rpm'
      )
    end
  end
end
