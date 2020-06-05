FROM ubuntu:18.04 as latex-base

ENV DEBIAN_FRONTEND noninteractive

RUN apt update 
RUN apt install -y build-essential \
    wget \
    git  \
    latexmk \
    texlive-full \
    curl && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /latex

RUN mkdir /scratch
ENV SCRATCH=/scratch

## Install latex packages
CMD ["/bin/bash"]

# Setup dev environment: vim with .vimrc and coc.nvim + texlab for autocomplete
FROM latex-base as latex-dev
RUN apt update && apt install -y wget git

WORKDIR /terraform
RUN  git clone https://github.com/mmorse1217/terraform --recursive .
RUN apt install -y sudo

RUN bash dotfiles/setup.sh
RUN bash vim/build_from_source.sh
RUN bash vim/lang-servers/setup.sh
RUN bash vim/lang-servers/texlab.sh
RUN bash vim/install_plugins.sh
CMD ["/bin/bash"]
