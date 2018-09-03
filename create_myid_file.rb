require "net/ssh"
require "json"

def create_myid_file_in_zk_cluster(filename)
    file = File.read filename
    data = JSON.parse(file)

    username = data["username"]
    password = data["password"]
    if password == "ENV"
        password = ENV['ZK_CLUSTER_PASSWORD']
    end
    hosts = data["hosts"]

    hosts.each do |host|
        Net::SSH.start(host,username,:password=>password) do |ssh|
            host_index_plus_one  = hosts.index(host) +1
            statement = 'echo ' + host_index_plus_one.to_s + ' > /zookeeper/data/myid'
            ssh.exec!(statement)
            ssh.exec!("exit")
        end
    end
end

create_myid_file_in_zk_cluster('variables.json')