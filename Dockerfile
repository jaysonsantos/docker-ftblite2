# This is based on itzg/minecraft-server

FROM itzg/ubuntu-openjdk-7

MAINTAINER Rafael G. Martins <rafael@rafaelmartins.eng.br>

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget unzip paxctl

EXPOSE 25565

ADD start.sh /start

VOLUME ['/data']
ADD server.properties /tmp/server.properties
WORKDIR /data

CMD /start

ENV MOTD A Minecraft (FTBLite2) Server Powered by Docker
ENV LEVEL world
ENV JVM_OPTS -Xms2048m -Xmx2048m -XX:PermSize=128m
ENV VERSION 1.1.9
