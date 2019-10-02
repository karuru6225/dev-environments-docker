FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]

WORKDIR /root

RUN apt update 2> /dev/null
RUN apt install -y vim wget git 2> /dev/null
RUN apt install -y openssh-server 2> /dev/null

RUN git clone git://github.com/nodenv/nodenv.git /root/.nodenv
RUN git clone https://github.com/nodenv/node-build.git /root/.nodenv/plugins/node-build

RUN mkdir -p /root/.vim/colors/
RUN wget https://raw.githubusercontent.com/karuru6225/vim-hybrid/master/colors/hybrid.vim -O /root/.vim/colors/hybrid.vim

COPY .vimrc /root
COPY .tmux.conf /root
COPY .colorrc /root
COPY .bashrc_additional /root/.bashrc_additional
RUN echo ". .bashrc_additional" >> /root/.bashrc
RUN . /root/.bashrc
RUN /root/.nodenv/bin/nodenv install --list
RUN /root/.nodenv/bin/nodenv install 12.11.1
RUN /root/.nodenv/bin/nodenv install 10.16.3
RUN /root/.nodenv/bin/nodenv global 12.11.1

RUN sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh
RUN mkdir /var/run/sshd
COPY playground.pub /tmp/playground.pub
RUN cat /tmp/playground.pub >> /root/.ssh/authorized_keys

CMD ["/usr/sbin/sshd", "-D"]
