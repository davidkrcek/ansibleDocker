FROM ubuntu:latest
RUN apt-get update
RUN apt-get install sudo
RUN apt-get install zsh -y && apt-get install -y git
RUN useradd -m -s /bin/zsh -G sudo ansible
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p /home/ansible/.ssh && mkdir -p /install/ansible
RUN chown -R ansible:users /home/ansible/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no\n" >> /home/ansible/.ssh/config
RUN apt-get install -y gcc python3 python3-pip; \
    apt-get install zsh git; \
    apt-get install -y wget curl openssh-client; \
    apt-get install -y locales-all;\
    apt-get clean all
USER ansible

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

RUN pip3 install --upgrade pip; 
RUN pip3 install ansible;

CMD ["/bin/zsh"]    
ENV PATH="/home/ansible/.local/bin:${PATH}"
WORKDIR /install/ansible
