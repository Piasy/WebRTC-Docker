#!/bin/bash

if [[ "$ENABLE_SHADOW_SOCKS" == "true" ]]
then
  sed -i "s/server-ip/$SHADOW_SOCKS_SERVER_ADDR/g" /etc/shadowsocks.json
  sed -i "s/server-port/$SHADOW_SOCKS_SERVER_PORT/g" /etc/shadowsocks.json
  sed -i "s/enc-method/$SHADOW_SOCKS_ENC_METHOD/g" /etc/shadowsocks.json
  sed -i "s/your-password/$SHADOW_SOCKS_ENC_PASS/g" /etc/shadowsocks.json

  sslocal -c /etc/shadowsocks.json -d start
  proxychains bash
else
  bash
fi
