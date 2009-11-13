script "install-mongo" do
  interpreter "bash"
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
  wget http://downloads.mongodb.org/linux/mongodb-linux-x86_64-1.0.0.tgz
  tar -zxf mongodb-linux-x86_64-1.0.0.tgz
  mv mongodb-linux-x86_64-1.0.0 /usr/local/mongodb
  rm mongodb-linux-x86_64-1.0.0.tgz
  EOH
  not_if do File.directory?("/usr/local/mongodb") end
end

directory "/db/mongodb/masterdb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if do File.directory?("/db/mongodb/masterdb") end
end

directory "/db/mongodb/slavedb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if do File.directory?("/db/mongodb/slavedb") end
end

remote_file "/etc/init.d/mongodb" do
  source "mongodb"
  owner "root"
  group "root"
  mode 0755
  not_if do File.exists?("/etc/init.d/mongodb") end
end

# service "mongodb" do
#   action [ :start ]
# end

execute "run-mongodb" do
  command %Q{
    /etc/init.d/mongodb start
  }
end
