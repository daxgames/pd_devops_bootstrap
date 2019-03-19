#
# Cookbook Name:: pd_devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'pd_devops_bootstrap::ubuntu' do
  context 'When all attributes are default, on ubuntu' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '14.04') do |node|
      end
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    %w(atom chrome firefox git vagrant virtualbox zsh).each do |recipe|
      it "include the #{recipe} recipe" do
        expect(chef_run).to include_recipe("pd_devops_bootstrap::#{recipe}")
      end
    end
  end
end
