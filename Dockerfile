FROM ubuntu:18.04 as latex-base

# From https://github.com/blang/latex-docker/blob/master/Dockerfile.basic
ENV DEBIAN_FRONTEND noninteractive

RUN apt update 
RUN apt install -y build-essential \
    wget \
    git  \
    latexmk \
    texlive-latex-extra \
    texlive-science \
    curl && \
    rm -rf /var/lib/apt/lists/*
#
#ENV HOME /data
#WORKDIR /data
#
## Install latex packages
CMD ["/bin/bash"]

FROM latex-base as latex-dev
RUN apt update && apt install -y wget git

WORKDIR /terraform
RUN  git clone https://github.com/mmorse1217/terraform --recursive .
RUN apt install -y sudo
#
RUN bash dotfiles/setup.sh
RUN bash vim/build_from_source.sh
#RUN apt install -y curl  
#RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
#RUN apt update
#RUN apt install -y nodejs yarn
# #RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - 
# #RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list 
# #RUN apt  update && apt install -y yarn 
RUN bash vim/lang-servers/setup.sh
RUN bash vim/lang-servers/texlab.sh
RUN bash vim/install_plugins.sh
CMD ["/bin/bash"]
#
