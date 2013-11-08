#
# Cookbook Name:: rackbox
# Recipe:: default
#

include_recipe "appbox"
include_recipe "rackbox::ruby"
include_recipe "rackbox::nginx"
include_recipe "runit"

%w(sv service).each do |dirname|
  directory File.join(node["appbox"]["apps_dir"], dirname) do
    owner node["appbox"]["apps_user"]
    group node["appbox"]["apps_user"]
    action :create
  end
end

runit_service "runsvdir-#{node["appbox"]["apps_user"]}" do
  run_template_name "runsvdir-user"
  log_template_name "runsvdir-user"
  options(
    :user  => node["appbox"]["apps_user"],
    :group => node["appbox"]["apps_user"]
  )
end

if node["rackbox"]["apps"]["unicorn"]
  include_recipe "rackbox::unicorn"
end

if node["rackbox"]["apps"]["passenger"]
  include_recipe "rackbox::passenger"
end
