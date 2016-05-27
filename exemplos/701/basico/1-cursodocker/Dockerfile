FROM ubuntu
MAINTAINER Leandro Augusto <leandro@zaytech.com.br>

# LABEL'S
LABEL "com.example.vendor"="Udemy Course"
LABEL version="1.0"
LABEL description="Curso de Docker: \
Exemplo basico de Dockerfile."

# Variaveis
ENV DIR_BASE=/usr/src
ENV DIR_TESTE1=$DIR_BASE/teste1
ENV USER=leandro
ENV PASS=12345


# Adiciona arquivos 
ADD arquivos/exemplos/ $DIR_BASE/exemplos
ADD arquivos/apt_defaults.pgks /tmp/apt_defaults.pgks

# Executa processos
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install autoconf build-essential gcc make 
RUN apt-get install -y -q $(cat /tmp/apt_defaults.pgks)

RUN locale-gen pt_BR.UTF-8
RUN update-locale LANG=pt_BR.UTF-8

# Local de trabalho
WORKDIR $DIR_BASE
RUN touch exemplo05.txt

WORKDIR $DIR_BASE/exemplos
RUN touch exemplo06.txt
RUN touch exemplo07.txt

#########################################################

# PORTS
EXPOSE 80
EXPOSE 81
EXPOSE 82 83

# VOLUMES
VOLUME ["/usr/src", "/home"]


#########################################################

# CMD
CMD ["/bin/bash"]

WORKDIR /etc
RUN touch exemplo08.txt
