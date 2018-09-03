require 'net/scp'
require "net/ssh"
require "json"

def upload_enable_zkServer_shell_script_to_server(filename)
    file = File.read filename
    data = JSON.parse(file)

    username = data["username"]
    password = data["password"]
    if password == "ENV"
        password = ENV['ZK_CLUSTER_PASSWORD']
    end
    puts password
    hosts = data["hosts"]
    source_file_path = data["source_file_path"]
    destination_file_path = data["destination_file_path"]

    hosts.each do |host|
        Net::SCP.upload!(host, username,source_file_path, destination_file_path,:ssh => { :password => password })
        Net::SSH.start(host,username,:password=>password) do |ssh|
            statement_defaults = 'sudo update-rc.d -f zkServer.sh defaults'
            statement_enable = 'sudo update-rc.d -f zkServer.sh enable'
            ssh.exec statement_defaults
            ssh.exec statement_enable
        end
    end
end