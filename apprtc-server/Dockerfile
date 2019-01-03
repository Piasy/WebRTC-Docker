FROM ubuntu:xenial
LABEL maintainer="Piasy Xu (xz4215@gmail.com)"

EXPOSE 8080 8089 3478 3033 59000-65000

WORKDIR /

ENV GAE_VER 1.9.74
ENV GOLANG_VER 1.8.3
ENV LIBEVENT_VER 2.1.8
ENV COTURN_VER 4.5.0.7

ENV PUBLIC_IP 127.0.0.1

RUN apt-get update -y

# Deps
RUN apt-get install -y build-essential vim git curl wget unzip python2.7 python-pil python-webtest python-pip libssl-dev openjdk-8-jdk
RUN pip install requests

# NodeJS
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

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
RUN wget https://github.com/libevent/libevent/releases/download/release-$LIBEVENT_VER-stable/libevent-$LIBEVENT_VER-stable.tar.gz
RUN tar xvfz libevent-$LIBEVENT_VER-stable.tar.gz
WORKDIR libevent-$LIBEVENT_VER-stable
RUN ./configure && make && make install
WORKDIR /
RUN wget http://turnserver.open-sys.org/downloads/v$COTURN_VER/turnserver-$COTURN_VER.tar.gz
RUN tar xvfz turnserver-$COTURN_VER.tar.gz
WORKDIR turnserver-$COTURN_VER
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
COPY constants.py /apprtc/out/app_engine/constants.py

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY run.sh /
RUN chmod +x /run.sh
CMD /run.sh
