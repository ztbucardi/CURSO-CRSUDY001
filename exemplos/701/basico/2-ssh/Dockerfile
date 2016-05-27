FROM ztbucardi/cursodocker-base 
MAINTAINER Leandro Augusto <leandro@zaytech.com.br>

# LABEL'S
LABEL "com.example.vendor"="Udemy Course"
LABEL version="1.0"
LABEL description="Curso de Docker: \
Exemplo basico de Dockerfile."

# Variaveis
ENV DIR_BASE=/usr/src
ENV DIR_TESTE1=$DIR_BASE/teste1
ENV USER=root
ENV PASS=12345

# Executa processos
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get -y upgrade

# Configura ssh
RUN apt-get install -y -q openssh-server
RUN mkdir /var/run/sshd
RUN echo $USER:$PASS |chpasswd
RUN sed -i "s/PermitRootLogin without-password/PermitRootLogin yes/g" /etc/ssh/sshd_config

#########################################################

# PORTS
EXPOSE 22

# CMD
CMD ["/usr/sbin/sshd", "-D"]
