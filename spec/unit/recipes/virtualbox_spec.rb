#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::virtualbox' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs virtualbox' do
      expect(chef_run).to install_chocolate('virtualbox')
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

    it 'installs virtualbox' do
      expect(chef_run).to install_cask('virtualbox')
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

    it 'includes the apt recipe' do
      expect(chef_run).to include_recipe('apt')
    end

    it 'installs virtualbox' do
      expect(chef_run).to install_apt_package('virtualbox')
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

    it 'adds the virtualbox repo' do
      expect(chef_run).to create_yum_repository('virtualbox').with(
        baseurl: "http://download.virtualbox.org/virtualbox/rpm/el/$releasever/$basearch",
        gpgkey: 'https://www.virtualbox.org/download/oracle_vbox.asc',
        gpgcheck: false,
        enabled: true
      )
    end

    it 'installs dependencies for virtualbox' do
      %w(binutils qt gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms).each do |package|
        expect(chef_run).to install_yum_package(package)
      end
    end

    it 'updates yum' do
      expect(chef_run).to run_bash('yum update').with(
        code: 'yum update'
      )
    end

    it 'installs virtualbox' do
      expect(chef_run).to install_yum_package('VirtualBox-5.0')
    end
  end
end
