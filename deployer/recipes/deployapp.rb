#
# Cookbook Name:: deploy
# Recipe:: deployapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

log 'message' do
  message "A ver donde estas"
  level :info
end

Chef::Log.info "About to search apps"

# Search apps to be deployed. Without deploy:true filter all apps would be returned.
apps = search(:aws_opsworks_app, "deploy:true") rescue []
Chef::Log.info "Found #{apps.size} apps to deploy on the stack. Assuming they are all Node.JS apps."

apps.each do |app|
  Chef::Log.info "Deploying #{app["shortname"]}."

  app_source = app["app_source"]
  app_checkout = ::File.join(Chef::Config["file_cache_path"], app["shortname"])

end





#node[:deploy].each do |app_name, deploy|
#   file "c:\\inetput\\wwwroot\\index.html" do
#      content IO.read("#{deploy[:deploy_to]}\\current\\index.html")
#      action :create
#   end
#end

