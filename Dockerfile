FROM ubuntu:20.04
ENV ANSIBLE_VERSION 9.5.1
RUN adduser --disabled-password --gecos ''
RUN adduser docker sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/ansible/.ssh && mkdir -p /install/ansible
RUN chown -R ansible:users /home/ansible/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no\n" >> /home/ansible/.ssh/config

RUN apt-get update; \
    apt-get install -y gcc python3; \
    apt-get install -y python3-pip; \
    apt-get install zsh -y && apt-get install -y git; \
    apt-get install -y openssh-client; \
    apt-get install -y wget; \
    apt-get clean all
USER ansible
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions
RUN pip3 install --upgrade pip; \
    pip3 install "ansible==${ANSIBLE_VERSION}"; \
    pip3 install ansible
CMD ["/bin/zsh"]    
WORKDIR /install/ansible
