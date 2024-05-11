FROM ubuntu:latest
RUN apt-get update
RUN apt-get install sudo
RUN apt-get install zsh -y && apt-get install -y git
RUN useradd -m -s /bin/zsh -G sudo ansible
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/ansible/.ssh && mkdir -p /install/ansible
RUN chown -R ansible:users /home/ansible/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no\n" >> /home/ansible/.ssh/config
RUN apt-get install -y gcc python3; \
    apt-get install -y python3-pip; \
    apt-get install zsh -y && apt-get install -y git; \
    apt-get install -y wget && apt-get install -y curl; \
    apt-get install -y openssh-client; \
    apt-get clean all
USER ansible

ENV ZSH_THEME="powerlevel10k/powerlevel10k"
RUN sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-completions


# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
#     -t https://github.com/denysdovhan/spaceship-prompt \
#     -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
#     -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
#     -p git \
#     -p ssh-agent \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions

RUN pip3 install --upgrade pip; 
RUN pip3 install ansible;

CMD ["/bin/zsh"]    
ENV PATH="/home/ansible/.local/bin:${PATH}"
    WORKDIR /install/ansible
