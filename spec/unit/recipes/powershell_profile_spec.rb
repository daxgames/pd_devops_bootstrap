#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::powershell_profile' do
  context 'When all attributes are default, on windows' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates a template for proxy settings' do
      # skip 'Needs implementaion'
      expect(chef_run).to create_template_if_missing('WindowsPowerShell\v1.0/profile.ps1').with(
        source: 'global_profile.ps1.erb'
      )
    end
  end
end
