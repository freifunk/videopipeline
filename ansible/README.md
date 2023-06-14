# Ansible Automation

## Preparation

1. Install Ansible using [this](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) installation guide.

2. Install roles:


     ```ansible-galaxy install geerlingguy.apache```
     
    ```ansible-galaxy install geerlingguy.certbot```

## Pipeline Configuration
1. The pipeline configuration variables need to be set in `pipelines/processing-pipeline.gocd.yaml` file.
2. `VOCTOWEB_URL` is the address of your deployed voctoweb instance.
3. `API_KEY` is API key of voctoweb (you can get it in your voctoweb dashboard).
4. `CDN_ADDRESS` is the address of the CDN where the processed videos will be uploaded.
5. `CDN_SERVER_USERNAME` is the username of cdn server using which we login to the system using ssh to upload videos.
6. `CDN_FILES_FOLDER` is the path where processed videos need to be uploaded (ex: `/srv/files`).
7. After the configuration variables are setup you need to commit and push those changes. THIS STEP IS VERY IMPORTANT.
   

## Deploy

run the gocd-server-playbook.yaml playbook to provision the gocd server

`ansible-playbook -i hosts.yaml gocd-server-playbook.yaml -u andibraeu --ask-become-pass`

run the gocd-agent-playbook.yaml playbook to provision the gocd agent machines

`ansible-playbook gocd-agent-playbook.yaml -u vijay --ask-become-pass`
