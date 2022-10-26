#!/bin/bash
set -e
mkdir -p /opt/trex
cd /opt/trex
wget --no-cache --no-check-certificate  https://trex-tgn.cisco.com/trex/release/latest
tar -zxvf latest
cat <<EOF > /etc/trex_cfg.yaml
- version: 2
  port_limit: 2
  interfaces: ["eth1", "eth2"]
  port_info:
  - ip: 100.64.0.1
    default_gw: 100.64.0.254
  - ip: 100.64.255.1
    default_gw: 100.64.255.254
EOF
