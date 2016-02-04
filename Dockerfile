FROM node:5

VOLUME /var/games/minecraft

# Arbitrarily assigned ports for 5 servers. change if you need to.
EXPOSE 22 8443 25565-25569

#i want jdk8, so enable debian testing
RUN echo "deb http://ftp.us.debian.org/debian/ testing main" >> /etc/apt/sources.list

#update and accept all prompts
RUN apt-get update -y && apt-get install -y \
  sudo \
  openssh-server \
  uuid \
  pwgen \
  supervisor \
  rdiff-backup \
  screen \
  openjdk-8-jre-headless \
  rsync \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd
RUN mkdir -p /usr/games/minecraft
RUN git clone git://github.com/hexparrot/mineos-node /usr/games/minecraft

WORKDIR /usr/games/minecraft
RUN npm install

COPY init/supervisord/* /etc/supervisor/conf.d/
COPY *.sh ./

RUN chmod +x *.sh
RUN useradd -s /bin/bash -d /usr/games/minecraft -m minecraft

ENTRYPOINT ["./start.sh"]
