#cloud-config
chpasswd: {expire: False}    
disable_root: 0
hostname: ${node_name}
ssh_authorized_keys:
  - ${ssh_key}
runcmd:  
  - ${node_command} ${node_role} --node-name ${node_name}
