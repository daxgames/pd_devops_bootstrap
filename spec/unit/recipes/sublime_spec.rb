#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::sublime' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs sublime' do
      expect(chef_run).to install_chocolate('sublimetext2')
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

    it 'installs sublime' do
      expect(chef_run).to install_cask('sublime-text')
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

    it 'adds tge sublime repo' do
      expect(chef_run).to add_apt_repository('sublime').with(
        uri: 'ppa:webupd8team/sublime-text-2',
        distribution: 'trusty',
        components: ['main']
      )
    end

    it 'installs chrome' do
      expect(chef_run).to install_apt_package('sublime-text')
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

    it 'installs sublime' do
      expect(chef_run).to run_bash('install sublime').with(
        code: <<-EOH
cd ~
curl http://c758482.r82.cf2.rackcdn.com/Sublime%20Text%202.0.2%20x64.tar.bz2 > sublime.tar.bz2
tar vxjf sublime.tar.bz2
mv 'Sublime Text 2' /opt/SublimeText2
ln -s /opt/SublimeText2/sublime_text /usr/bin/sublime
        EOH
      )
    end
  end
end
