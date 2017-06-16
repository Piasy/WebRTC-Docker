FROM ubuntu:xenial
MAINTAINER Piasy Xu (xz4215@gmail.com)

WORKDIR /

ENV ENABLE_SHADOW_SOCKS true
ENV SHADOW_SOCKS_SERVER_ADDR 127.0.0.1
ENV SHADOW_SOCKS_SERVER_PORT 8000
ENV SHADOW_SOCKS_ENC_METHOD encmethod
ENV SHADOW_SOCKS_ENC_PASS encpass

RUN apt-get update -y

# Deps
RUN apt-get install -y build-essential vim git python-pip proxychains wget
RUN pip install shadowsocks

# libsodium
RUN wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.12.tar.gz
RUN tar zxf libsodium-1.0.12.tar.gz
WORKDIR /libsodium-1.0.12
RUN ./configure && make && make install
RUN echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf && ldconfig

WORKDIR /
RUN mkdir ~/.proxychains
COPY proxychains.conf ~/.proxychains/proxychains.conf
COPY shadowsocks.json /etc/shadowsocks.json

COPY build.sh /
RUN echo 'source /build.sh' > ~/.bashrc
COPY run.sh /
RUN chmod +x /run.sh
CMD /run.sh
