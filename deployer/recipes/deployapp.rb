#
# Cookbook Name:: deploy
# Recipe:: deployapp
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
node[:deploy].each do |app_name, deploy|
   file "c:\\inetput\\wwwroot\\index.html" do
      content IO.read("#{deploy[:deploy_to]}\\current\\index.html")
      action :create
   end
end

