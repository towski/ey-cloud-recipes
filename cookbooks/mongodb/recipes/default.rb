script "install-mongo" do
  interpreter "bash"
  user "root"
  cwd "/usr/local"
  code <<-EOH
  wget -O - http://downloads.mongodb.org/linux/mongodb-linux-i686-1.4.2.tgz | tar xzf -
  ln -nfs /usr/local/mongodb-linux-i686-1.4.2 /usr/local/mongodb
  EOH
  not_if { File.directory?("/usr/local/mongodb-linux-i686-1.4.2") }
end

directory "/db/mongodb/masterdb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?("/data/mongodb/masterdb") }
end

directory "/db/mongodb/slavedb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?("/data/mongodb/slavedb") }
end

directory "/var/run/masterdb" do
  owner node[:owner_name]
  group node[:owner_name]
  mode 0755
  recursive true
  not_if { File.directory?("/var/run/masterdb") }
end

remote_file "/etc/init.d/mongodb" do
  source "mongodb"
  owner "root"
  group "root"
  mode 0755
end

execute "adduser-mongodb" do
  command %Q{
    adduser mongodb
  }
end

#execute "run-mongodb" do
#  command %Q{
#    /etc/init.d/mongodb start
#  }
#end
