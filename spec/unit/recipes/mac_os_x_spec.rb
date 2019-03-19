#
# Cookbook Name:: devops_bootstrap
# Spec:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'devops_bootstrap::mac_os_x' do
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

    it 'includes homebrew recipe' do
      expect(chef_run).to include_recipe('homebrew')
    end

    it 'includes homebrew::cask recipe' do
      expect(chef_run).to include_recipe('homebrew::cask')
    end

    %w(atom chrome caffeine firefox git iterm2 opera spectacle squidman vagrant virtualbox zsh).each do |recipe|
      it "include the #{recipe} recipe" do
        expect(chef_run).to include_recipe("devops_bootstrap::#{recipe}")
      end
    end
  end
end
