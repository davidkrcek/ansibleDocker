FROM ubuntu:latest
# Update the repositories and refresh system
RUN apt-get update
# Install zsh and git
RUN apt-get install zsh git sudo -y 
# Add local certificates for zscaler & Co. support later in git
RUN apt-get install apt-transport-https ca-certificates -y 
ADD ./cacerts/* /usr/local/share/ca-certificates/
RUN update-ca-certificates 
# create ansible user
RUN useradd -m -s /bin/zsh -G sudo ansible
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/ansible/.ssh && mkdir -p /install/ansible
RUN chown -R ansible:users /home/ansible/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no\n" >> /home/ansible/.ssh/config

# Install Pyhton3 and Python3-pip and other tools
# and clean up all
RUN apt-get install -y gcc python3 python3-pip python3-venv
RUN apt-get install -y wget curl openssh-client 
RUN apt-get install -y locales-all
RUN apt-get clean all

#switch to ansible user and install and configure zsh/ohmayzsh
USER ansible
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:/home/ansible/.local/bin:$PATH"
ENV ZSH="/home/ansible/.oh-my-zsh"
RUN sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH/custom/plugins/zsh-autosuggestions" ; \
    git clone https://github.com/zsh-users/zsh-completions "$ZSH/custom/plugins/zsh-completions"; \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "$ZSH/custom/plugins/zsh-history-substring-search"; \
    git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH/custom/themes/spaceship-prompt" ; \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH/custom/plugins/zsh-syntax-highlighting" ;\
    git clone --depth 1 https://github.com/junegunn/fzf.git "/home/ansible/.fzf" ;\
    /home/ansible/.fzf/install
ADD zshrc_config.txt ~/.zshrc
# RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)" -- \
#     -t https://github.com/denysdovhan/spaceship-prompt \
#     -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
#     -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
#     -p git \
#     -p ssh-agent \
#     -p https://github.com/zsh-users/zsh-autosuggestions \
#     -p https://github.com/zsh-users/zsh-completions

# Upgrade pip to the lastest in user context
RUN pip3 install --upgrade pip; 
# Finaly install Ansible and set environment
RUN pip3 install ansible;
CMD ["/bin/zsh"]    

# Set workdir to your ansible direcotry
WORKDIR /install/ansible