#
# Cookbook Name:: vagrant-alike
# Recipe:: default
#
# Copyright (C) 2013 Hidekazu Tanaka
#
# All rights reserved - Do Not Redistribute
#

link '/usr/share/ant/lib/ivy.jar' do
  to '/usr/share/java/ivy.jar'
end

include_recipe 'vagrant-alike::opencv'

%w(curl python-pip subversion unzip).each do |pkg|
  package pkg do
    action :install
  end
end

execute 'pip install solrpy'

subversion 'Apache alike' do
  repository 'http://svn.apache.org/repos/asf/labs/alike/trunk'
  revision 'HEAD'
  destination '/home/vagrant/alike'
  action :sync
  user 'vagrant'
  group 'vagrant'
end


%w(schema.xml solrconfig.xml).each do |file|
  link "/usr/share/solr/collection1/conf/#{file}" do
    to "/home/vagrant/alike/demo/solrhome/collection1/conf/#{file}"
  end
end

service 'jetty' do
  supports :status => true, :restart => true, :reload => true
  action :restart
end
