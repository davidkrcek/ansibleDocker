# Latest Minimal Ubuntu Image
FROM ubuntu:latest

# Environments
ARG ANSIBLE_USER="ansible"
ARG ANSIBLE_USER_UID="1002"
ARG ANSIBLE_HOME="/home/ansible"
ARG ANSIBLE_WORKDIR="/install/ansible"
ENV VENV_NAME="${ANSIBLE_HOME}/venv"

# Update the repositories and refresh system
RUN apt-get update

# Install zsh and git
RUN apt-get install zsh git sudo -y 
# Install Pyhton3 and Python3-pip and other tools
# and clean up all
RUN apt-get install -y gcc python3 python3-pip python3-venv ; \
    apt-get install -y wget curl openssh-client vim ; \
    apt-get install -y locales-all
RUN apt-get clean all

# Add local certificates for zscaler & Co. support later in git
RUN apt-get install apt-transport-https ca-certificates -y 
COPY config/cacerts /tmp/cacerts
RUN mv /tmp/cacerts/* /usr/local/share/ca-certificates/
#COPY ./cacerts* /usr/local/share/ca-certificates/
RUN update-ca-certificates 

# create ansible user 
RUN useradd -m -s /bin/zsh -u "${ANSIBLE_USER_UID}" -G sudo "${ANSIBLE_USER}"
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN mkdir -p "${ANSIBLE_HOME}"/.ssh && mkdir -p "${ANSIBLE_WORKDIR}"
RUN chown -R ansible:ansible "${ANSIBLE_HOME}"/.ssh
RUN echo "Host * \n\tStrictHostKeyChecking no\n" >> "${ANSIBLE_HOME}"/.ssh/config

#switch to ansible user and install and configure zsh/ohmayzsh
USER ansible
SHELL ["/bin/bash", "-c"]

RUN python3 -m venv "${VENV_NAME}"

RUN source "${VENV_NAME}"/bin/activate 
ENV PATH="${VENV_NAME}/bin:/home/ansible/.local/bin:${PATH}"
ENV ZSH="/home/ansible/.oh-my-zsh"

RUN sh -c "$(curl https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
RUN git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH}/custom/plugins/zsh-autosuggestions" ; \
    git clone https://github.com/zsh-users/zsh-completions "${ZSH}/custom/plugins/zsh-completions"; \
    git clone https://github.com/zsh-users/zsh-history-substring-search.git "${ZSH}/custom/plugins/zsh-history-substring-search"; \
    git clone https://github.com/denysdovhan/spaceship-prompt.git "${ZSH}/custom/themes/spaceship-prompt" ; \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH}/custom/plugins/zsh-syntax-highlighting" ;\
    git clone --depth 1 https://github.com/junegunn/fzf.git "/home/ansible/.fzf" ;\
    /home/ansible/.fzf/install


# Upgrade pip to the lastest in user context
RUN pip3 install --upgrade pip; 
# Finaly install Ansible and set environment
RUN pip3 install ansible;

# copy ssh keys and ZSH configuration into image
COPY ./config/zsh/.zshrc ${ANSIBLE_HOME}/.zshrc
COPY ./config/ssh_keys/. ${ANSIBLE_HOME}/.ssh/

RUN sudo chmod 600 ${ANSIBLE_HOME}/.ssh/id_rsa*
RUN sudo chown -R ansible:ansible ${ANSIBLE_HOME}/.ssh
RUN sudo chown -R ansible:ansible ${ANSIBLE_HOME}/.zshrc


# Set the default shell to zsh
CMD ["/bin/zsh"]    

# Set workdir to your ansible direcotry
WORKDIR {{ ANSIBLE_WORKDIR }}