#
# Cookbook Name:: pd_devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pd_devops_bootstrap::default' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'does not include the mac_os_x recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::mac_os_x'
    end

    it 'does not include the centos_rhel recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::centos_rhel'
    end

    it 'includes the windows recipe' do
      expect(chef_run).to include_recipe 'pd_devops_bootstrap::windows'
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

    it 'does not include the windows recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::windows'
    end

    it 'does not include the centos_rhel recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::centos_rhel'
    end

    it 'includes the mac_os_x recipe' do
      expect(chef_run).to include_recipe 'pd_devops_bootstrap::mac_os_x'
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

    it 'does not include the windows recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::windows'
    end

    it 'does not include the mac_os_x recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::mac_os_x'
    end

    it 'does not include the centos_rhel recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::centos_rhel'
    end

    it 'includes the ubuntu recipe' do
      expect(chef_run).to include_recipe 'pd_devops_bootstrap::ubuntu'
    end
  end

  context 'When all attributes are default, on ubuntu' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'does not include the windows recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::windows'
    end

    it 'does not include the mac_os_x recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::mac_os_x'
    end

    it 'does not include the ubuntu recipe' do
      expect(chef_run).to_not include_recipe 'pd_devops_bootstrap::ubuntu'
    end

    it 'includes the centos_rhel recipe' do
      expect(chef_run).to include_recipe 'pd_devops_bootstrap::centos_rhel'
    end
  end
end
