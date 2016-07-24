#
# Cookbook Name:: deploy
# Recipe:: deployapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log 'message' do
  message "A ver donde estas"
  level :info
end

Chef::Log.info "Buscando aplicaciones"

apps = search(:aws_opsworks_app, "deploy:true") rescue []
Chef::Log.info "Encontradas #{apps.size} apps para deploy en el stack."

apps.each do |app|
  Chef::Log.info "Desplegando #{app["shortname"]}."

  app_source = app["app_source"]
  app_checkout = ::File.join(Chef::Config["file_cache_path"], app["shortname"])
  
  opsworks_scm_checkout app["shortname"] do
    destination      app_checkout
    repository       app_source["url"]
    revision         app_source["revision"]
    user             app_source["username"]
    password         app_source["password"]
    ssh_key          app_source["ssh_key"]
    type             app_source["type"]
  end

  app_deploy = ::File.join(node["deployer"]["deploydir"], app["shortname"])

  directory app_deploy do
    action :create
    recursive true
    rights :full_control, "IIS_IUSRS", :applies_to_children => true, :applies_to_self => true if platform?("windows")
  end

# Copy app
  batch "copy #{app["shortname"]}" do
    code "Robocopy.exe #{app_checkout} #{app_deploy} /MIR"
    returns (0..7).to_a
  end

end
