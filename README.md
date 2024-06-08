[![Docker](https://github.com/davidkrcek/ansibleDocker/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/davidkrcek/ansibleDocker/actions/workflows/docker-publish.yml)

# Ansible Docker Container

This Docker image is based on the latest minimal Ubuntu version and is prepared for use with Ansible.
It includes various tools and configurations to facilitate working with Ansible.

## Table of Contents

- [Build](#build)
- [Usage](#usage)
- [Dockerfile Contents](#dockerfile-contents)
- [Configuration](#configuration)
- [Licenses](#licenses)

## Build

To build the Docker image, run the following command in the directory of the Dockerfile:

```bash
docker build -t ansible_docker .
```

## Usage

### Quickstart start from docker hub

```bash
docker run -it -d --name ansible_docker rotecodefraktion/ansible_docker
```

Mount an persistent directory (e.g /tmp/ansible_docker ) to the container run and name the container ansible

```bash
docker run -v /tmp/docker_ansible:/install/ansible -it -d --name ansible_docker rotecodefraktion/ansible_docker
```

You can create a fresh ssh key-pair with ssh-keygen inside the container or you can use your own ssh key from outside the container. To copy your own ssh-key to the container:

```bash
docker cp ~/.ssh/id_rsa ansible_docker:/home/ansible/.ssh/
docker exec -u 0 -it ansible_docker chown ansible:ansible /home/ansible/.ssh/id_rsa
docker exec -it ansible_docker /bin/zsh
```

### Build your on image

```bash
git clone ttps://github.com/davidkrcek/docker_ansible.git
docker build -t ansible_docker .
docker run -it -d --name ansible_docker ansible_docker
```

The container will start with the zsh shell, and you will be in the working directory for Ansible.

## Dockerfile Contents

The Dockerfile installs the following packages and configures the environment:

- Base Image: Latest version of Ubuntu.

  - gcc
  - python3 python3-pip python3-venv
  - wget curl
  - openssh-client
  - vim
  - zsh
  - ohmyzsh
  - git
  - sudo

- Environment Variables: Configures user and directories for Ansible.
- User Creation: Creates a new user ansible and configures its environment.
- Zsh and Oh My Zsh: Installs and configures zsh and Oh My Zsh with plugins and themes.
- Python and Ansible: Installs Python3, pip, and Ansible within a Python virtual environment.
- SSH Configuration: Copies SSH keys and configurations to the home directory of the Ansible user.

## Configuration

To customize the configuration, modify the corresponding environment variables in the Dockerfile.

- ANSIBLE_USER: ansible or any other user inside the container which connects to the satellites
- ANSIBLE_USER_UID: 1002 or any other id, helps to read/write attached filesystems to the container
- ARG ANSIBLE_HOME: /home/ansible
- ANSIBLE_WORKDIR: attached directory from host to container

- Copy all ssh keys (private keys) from ./config/ssh_keys to ANSIBLE_HOME/.ssh/

  **Please use a allways a secret when generating private keys**

- If you build the docker image behind ZScaler or similar you can upload the necessary certificates to ./conifg/cacerts
  to avoid git certifcates errors

## Licenses

This project uses the following licenses:

- GPL-3.0 license
- Ubuntu: Ubuntu License (https://hub.docker.com/_/ubuntu)
- Zsh (https://github.com/zsh-users/zsh/tree/master)
- Oh My Zsh: (https://github.com/ohmyzsh/ohmyzsh)

  For more information on the licenses of the installed packages, please consult the respective documentation.
