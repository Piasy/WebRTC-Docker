# WebRTC-Docker for SSL

Out-of-the-box docker images for AppRTC dev/test purposes. Updated for SSL support.

+ Deploy the super slick https://appr.tc/ in your local docker env for personal enjoyment.
+ Note: FireFox/Chrome require valid SSL certificates to open WebRTC Audio/Video streams and thus run AppRTC

SSL Changes:

+ CA cert/key provided using Let'sEncrypt Pebble
+ SSL certs generated using hostname signed and deployed to /cert
+ GAE SSL params: dev_appserver.py /apprtc/out/app_engine --skip_sdk_update_check --enable_host_checking=False --host=0.0.0.0 --ssl_certificate_path=/cert/cert.pem --ssl_certificate_key_path=/cert/key.pem --specified_service_ports default:442
+ Collider (WS server in SSL mode): /goWorkspace/bin/collidermain -port=8089 -tls=true --room-server=0.0.0.0
+ ICE NodeJS app changed to start in HTTPS mode
+ run.sh changed to create host cert signed with CA certs using openssl
+ Docker file updated

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

Manual build Linux host (must have docker installed):
+ Copy files to your Linux host: git clone https://github.com/Shark-y/WebRTC-Docker rtc
+ Navigate to: apprtc-server then chmod +x *.sh
+ Run the bash commands below
+ Install the CA certificate (chain-pebble.pfx) in your FF/Chrome cert store 
+ Open https://MYHOSTNAME/

``` bash
$ mkdir rtc
$ git clone https://github.com/Shark-y/WebRTC-Docker rtc
$ cd rtc/apprtc-server
$ chmod +x *.sh
$ sudo ./build.sh         # Build the docker image - docker build -t webrtc . (takes 5mins to build)
$ sudo ./docker-run.sh    # create SSL certs for hostname and start servers
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
