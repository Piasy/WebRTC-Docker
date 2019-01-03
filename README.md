# WebRTC-Docker

Out-of-the-box docker images for AppRTC dev/test purpose.

## AppRTC-Server

macOS host:

``` bash
docker run --rm \
  -p 8080:8080 -p 8089:8089 -p 3478:3478 -p 3478:3478/udp -p 3033:3033 \
  -p 59000-65000:59000-65000/udp \
  -e PUBLIC_IP=<server public IP> \
  -it piasy/apprtc-server
```

Linux host:

``` bash
docker run --rm --net=host \
  -e PUBLIC_IP=<server public IP> \
  -it piasy/apprtc-server
```

About port publish:

+ TCP `8080` is used for room server;
+ TCP `8089` is used for signal server;
+ TCP `3033` is used for ICE server;
+ TCP `3478`, UDP `3478` and UDP `59000-65000` is used for TURN/STUN server;

So make sure your firewall has opened those ports.

## WebRTC-Build

Only Android/Linux is supported.

``` bash
docker run --rm \
  -e ENABLE_SHADOW_SOCKS=true \
  -e SHADOW_SOCKS_SERVER_ADDR=<your shadowsocks server ip> \
  -e SHADOW_SOCKS_SERVER_PORT=<your shadowsocks server port> \
  -e SHADOW_SOCKS_ENC_METHOD=<your shadowsocks encrypt method> \
  -e SHADOW_SOCKS_ENC_PASS=<your shadowsocks encrypt password> \
  -v <path to place webrtc source>:/webrtc \
  -it piasy/webrtc-build
```

Note: if your encrypt password contains special characters, remember to escape it with `\`, e.g. `&bDmc!` to `\&bDmc\!`.

If you don't need run shadowsocks proxy, you can run:

``` bash
docker run --rm \
  -v <path to place webrtc source>:/webrtc \
  -it piasy/webrtc-build
```

After the docker image started, you can run `fetch`, `gclient`, `gn`, and `ninja` commands to download and build webrtc code.
