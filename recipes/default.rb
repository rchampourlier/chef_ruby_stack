#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ruby_build"
include_recipe "rbenv::system_install"

Array(node['ruby_stack']['rubies']).each do |rubie|
  rbenv_ruby rubie

  # Adding Bundler to each rubie unless it's already in the rubie's
  # gems list
  unless node['ruby_stack']['gems'] && node['ruby_stack']['gems'][rubie].include("bundler")
    rbenv_gem "bundler" do
      rbenv_version rubie
    end
  end
end

if node['ruby_stack']['global']
  rbenv_global node['ruby_stack']['global']
end

if node['ruby_stack']['gems']
  node['ruby_stack']['gems'].each_pair do |rubie, gems|
    Array(gems).each do |gem|
      rbenv_gem gem['name'] do
        rbenv_version rubie

        %w{version action options source}.each do |attr|
          send(attr, gem[attr]) if gem[attr]
        end
      end
    end
  end
end

Array(node['ruby_stack']['users']).each do |user_name|
  user_dir = Etc.getpwnam(user_name).dir

  directory File.join(user_dir, ".bundle") do
    owner user_name
    group user_name
    mode "0755"
    action :create
  end

  template "#{user_dir}/.bundle/config" do
    source  "bundle_config.erb"
    owner user_name
    group user_name
    mode "0644"
  end
end