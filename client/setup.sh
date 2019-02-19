#!/bin/bash -e

# Copy all directories in place
rsync -rav ./ /

# Install packages
apt update
cat packages.list | xargs apt install -y

# Reload systemd
systemctl daemon-reaload

# Enable services
systemctl enable prometheus-node-exporter
systemctl enable ssh

# Create prometheus-tunnel user
useradd -b /srv -m prometheus-tunnel
sudo prometheus-tunnel -c ssh-keygen
chown -R prometheus-tunnel:prometheus-tunnel /srv/prometheus-tunnel

# Enable prometheus tunnel & discovery
systemctl enable prometheus-tunnel
systemctl enable prometheus-tunnel-discovery

# Start prometheus tunnel & discovery
systemctl start prometheus-tunnel
