#
# Cookbook Name:: configurer
# Recipe:: configurer
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
# stop and delete the default site

iis_site 'Default Web Site' do
  action [:stop, :delete]
end

Chef::Log.info "Buscando aplicaciones"

apps = search(:aws_opsworks_app, "configure:true") rescue []
Chef::Log.info "Encontradas #{apps.size} apps para configurar en el stack."

apps.each do |app|
  Chef::Log.info "Configurando #{app["shortname"]}."
  app_dir = ::File.join(node['iis']['docroot'], app["shortname"])


  directory app_dir do
    action :create
  end

  iis_site "#{app["shortname"]} Site" do
    protocol :http
    port 80
    path app_dir
    action [:add,:start]
  end

end


