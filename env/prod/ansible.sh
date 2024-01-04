#!/bin/bash
cd /home/ubuntu
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python3 get-pip.py
sudo python3 -m pip install ansible
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
  - name: install pyhton3 and virtualenv
    apt:
      pkg:
      - python3
      - virtualenv
      update_cache: yes
    become: yes
  - name: Git Clone
    ansible.builtin.git:
      repo: https://github.com/alura-cursos/clientes-leo-api.git
      dest: /home/ubuntu/rlindoso
      version: master
      force: yes
  - name: installing dependencies with pip (django and django rest)
    pip:
      virtualenv: /home/ubuntu/rlindoso/venv
      requirements: /home/ubuntu/rlindoso/requirements.txt
  - name: Set hosts in settings
    lineinfile:
      path: /home/ubuntu/rlindoso/setup/settings.py
      regexp: 'ALLOWED_HOSTS'
      line: 'ALLOWED_HOSTS = ["*"]'
      backrefs: yes
  - name: Config data base
    shell: '. /home/ubuntu/rlindoso/venv/bin/activate; python /home/ubuntu/rlindoso/manage.py migrate'
  - name: Load init data
    shell: '. /home/ubuntu/rlindoso/venv/bin/activate; python /home/ubuntu/rlindoso/manage.py loaddata clientes.json'
  - name: 'Start server'
    shell: '. /home/ubuntu/rlindoso/venv/bin/activate; nohup python /home/ubuntu/rlindoso/manage.py runserver 0.0.0.0:8000 &'
EOT
ansible-playbook playbook.yml