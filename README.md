# apprtc-docker

Dockerfile for apprtc


``` bash
docker run --rm \
  -p 8080:8080 -p 8089:8089 -p 3478:3478 \
  -e GOPATH=/goWorkspace \
  -e COLLIDER_STL=false \
  -e COLLIDER_PORT=8089 \
  -v <path to constants.py>:/apprtc_configs
  -t -i piasy/apprtc-server
```
