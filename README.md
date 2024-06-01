# Ansible Docker Container

This Docker image is based on the latest minimal Ubuntu version and is prepared for use with Ansible.
It includes various tools and configurations to facilitate working with Ansible.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Dockerfile Contents](#dockerfile-contents)
- [Configuration](#configuration)
- [Licenses](#licenses)

## Installation

To build the Docker image, run the following command in the directory of the Dockerfile:

```bash
docker build -t ansible-docker .
```

## Usage

To start a container based on this image, use the following command:

```bash
docker run -it ansible-docker
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

- CC BY-NC
- Ubuntu: Ubuntu License
- Zsh and Oh My Zsh: Zsh License
  For more information on the licenses of the installed packages, please consult the respective documentation.
