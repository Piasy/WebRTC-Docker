FROM ubuntu:xenial
MAINTAINER Piasy Xu (xz4215@gmail.com)

EXPOSE 8080 8089 3478 3033 59000-65000

WORKDIR /

ENV GAE_VER 1.9.54
ENV GOLANG_VER 1.8.3

ENV PUBLIC_IP 127.0.0.1

RUN apt-get update -y

# Deps
RUN apt-get install -y build-essential vim git wget unzip python2.7 python-pil python-webtest python-pip libssl-dev
RUN pip install requests

# NodeJS
RUN wget -O nodejs.sh https://deb.nodesource.com/setup_4.x
RUN chmod +x nodejs.sh
RUN sh ./nodejs.sh
RUN apt-get install -y nodejs
RUN ln -s -f /usr/bin/nodejs /usr/bin/node

# Golang
ENV GOLANG_TAR go$GOLANG_VER.linux-amd64.tar.gz
RUN wget https://storage.googleapis.com/golang/$GOLANG_TAR
RUN tar -C /usr/local -xzf $GOLANG_TAR
ENV PATH $PATH:/usr/local/go/bin
ENV GOPATH /goWorkspace
RUN mkdir -p $GOPATH/src

# Google App Engine
ENV GAE_ZIP google_appengine_$GAE_VER.zip
RUN wget https://storage.googleapis.com/appengine-sdks/featured/$GAE_ZIP
RUN unzip $GAE_ZIP -d /usr/local
ENV PATH $PATH:/usr/local/google_appengine

# Coturn server
RUN wget https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz
RUN tar xvfz libevent-2.0.21-stable.tar.gz
WORKDIR libevent-2.0.21-stable
RUN ./configure && make && make install
WORKDIR /
RUN wget http://turnserver.open-sys.org/downloads/v4.5.0.6/turnserver-4.5.0.6.tar.gz
RUN tar xvfz turnserver-4.5.0.6.tar.gz
WORKDIR turnserver-4.5.0.6
RUN ./configure && make && make install
RUN turnadmin -a -u ninefingers -r apprtc -p youhavetoberealistic
COPY turnserver.conf /etc/turnserver.conf

# AppRTC
WORKDIR /
RUN git clone https://github.com/webrtc/apprtc.git

WORKDIR apprtc

RUN ln -s /apprtc/src/collider/collider $GOPATH/src
RUN ln -s /apprtc/src/collider/collidermain $GOPATH/src
RUN ln -s /apprtc/src/collider/collidertest $GOPATH/src
RUN go get collidermain
RUN go install collidermain

RUN npm install -g npm
RUN npm install -g grunt-cli

RUN npm install
RUN grunt build

WORKDIR /

RUN npm install express
COPY ice.js /

COPY run.sh /
RUN chmod +x /run.sh
CMD /run.sh
