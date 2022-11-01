# Ansible Automation

## Preparation

1. Install Ansible using [this](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installation guide.

2. Install roles:


     ```ansible-galaxy install geerlingguy.apache```
     
    ```ansible-galaxy install geerlingguy.certbot```

## Deploy

run the gocd-server-playbook.yaml playbook to provision the gocd server

`ansible-playbook -i hosts.yaml gocd-server-playbook.yaml -u andibraeu --ask-become-pass`

run the gocd-agent-playbook.yaml playbook to provision the gocd agent machines

`ansible-playbook gocd-agent-playbook.yaml -u vijay --ask-become-pass`
