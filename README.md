Prometheus ssh reverse tunnel target scrape discovery example
---------------------------------------------------------------

This repository contains an example of how dynamic prometheus scrape target discovery can be done.

The idea is that you have many nodes running prometheus-node-exporter, some of which you may not be in control of.

In this case, you want to grant these nodes access to the prometheus server via SSH public key authentication and then have prometheus dynamically discover their scrape endpoint (and start scraping them) as they connect automatically.

## Setup

There are two directories, each is inteded for setting up:
* The _client(s)_, each running only _prometheus-node-exporter_.
* The _server_, the only node running _prometheus_.

### Server

1. Install ansible on your workstation (not the target server)
2. `cd` to the `server` directory
3. Run the playbook against the target host. e.g:

    ansible-playbook -u admin -i '1.2.3.4,' playbook.yml

### Client

1. Copy the entire `client` directory to the client host.
2. SSH to the client host and change user to root
3. `cd` to the `client` directory and run `./setup.sh`
4. Copy the ssh public key from `/srv/prometheus-tunnel/.ssh/id_rsa.pub` on the _client_ to `/srv/prometheus-tunnels/.ssh/authorized_keys` on the _server_
