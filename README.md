# WebRTC-Docker

Out-of-the-box docker images for AppRTC dev/test purpose.

## AppRTC-Server

``` bash
docker run --rm \
  -p 8080:8080 -p 8089:8089 -p 3478:3478 -p 3478:3478/udp -p 3033:3033 \
  -p 59000-65000:59000-65000/udp \
  -e PUBLIC_IP=<server public IP> \
  -v <path to constants.py parent folder>:/apprtc_configs \
  -t -i piasy/apprtc-server
```

About port publish:

+ `8080` is used for room server;
+ `8089` is used for signal server;
+ `3033` is used for ICE server;
+ `3478` and `59000-65000` is used for TURN/STUN server;

So make sure your firewall has opened those ports.

Note that publish range ports could be very slow and memory consuming, we can either replace all `-p` options into a single `--net=host` option, or disable userland proxy, see detail info in [this issue](https://github.com/moby/moby/issues/11185).

About how to modify `constants.py`, see [this example](https://github.com/Piasy/WebRTC-Docker/blob/master/apprtc-server/constants.py), `ICE_SERVER_BASE_URL`, `ICE_SERVER_URL_TEMPLATE` and `WSS_INSTANCES` has been modified.

## WebRTC-Build

Credit: the build script is based on [pristineio/webrtc-build-scripts](https://github.com/pristineio/webrtc-build-scripts).

``` bash
docker run --rm \
  -e ENABLE_SHADOW_SOCKS=true \
  -e SHADOW_SOCKS_SERVER_ADDR=<your shadowsocks server ip> \
  -e SHADOW_SOCKS_SERVER_PORT=<your shadowsocks server port> \
  -e SHADOW_SOCKS_ENC_METHOD=<your shadowsocks encrypt method> \
  -e SHADOW_SOCKS_ENC_PASS=<your shadowsocks encrypt password> \
  -v <path to place webrtc source>:/webrtc \
  -t -i piasy/webrtc-build
```

Note: if your encrypt password contains special characters, remember to escape it with `\`, e.g. `&bDmc!` to `\&bDmc\!`.

If you don't need run shadowsocks proxy, you can run:

``` bash
docker run --rm \
  -e ENABLE_SHADOW_SOCKS=false \
  -v <path to place webrtc source>:/webrtc \
  -t -i piasy/webrtc-build
```

After the docker image started, to get/update WebRTC code, run `get_webrtc`, to build WebRTC Android demo, run `build_apprtc`.

To get WebRTC code from a custom url, e.g. `https://webrtc.googlesource.com/src.git`, run `USER_WEBRTC_URL=https://webrtc.googlesource.com/src.git get_webrtc`. To create debug build, run `WEBRTC_DEBUG=true build_apprtc`.

Only Android is supported now, iOS support is working on, stay tuned!
