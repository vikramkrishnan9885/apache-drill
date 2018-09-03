require 'net/scp'
require "net/ssh"
require "json"

def upload_file_to_server_run_cmds(parameter_filename, command_file_name)

    file = File.read parameter_filename
    data = JSON.parse(file)

    commands = IO.readlines(command_file_name)
    commands_length = commands.size

    username = data["username"]
    password = data["password"]
    if password == "ENV"
        password = ENV['ZK_CLUSTER_PASSWORD']
    end

    hosts = data["hosts"]
    source_file_path = data["source_file_path"]
    destination_file_path = data["destination_file_path"]

    hosts.each do |host|
        Net::SCP.upload!(host, username,source_file_path, destination_file_path,:ssh => { :password => password })
        Net::SSH.start(host,username,:password=>password) do |ssh|
            max_val = commands_length-1
            for i in 0..max_val
                command = commands[i].chomp
                ssh.exec!(command)
            end
        end
    end
end