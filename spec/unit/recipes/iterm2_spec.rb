#
# Cookbook Name:: pd_devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pd_devops_bootstrap::iterm2' do
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

    it 'installs iterm2' do
      expect(chef_run).to install_cask('iterm2')
    end
  end
end
