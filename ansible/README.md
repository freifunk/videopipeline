# Ansible Automation

## Preparation

Install ansible

Install roles:
    * `ansible-galaxy install geerlingguy.apache`
    * `ansible-galaxy install geerlingguy.certbot`

## Deploy

run the the playbook with `ansible-playbook -i hosts.yaml gocd-server-playbook.yaml -u andibraeu --ask-become-pass`
