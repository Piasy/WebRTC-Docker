sed -i 's/wss:\/\//ws:\/\//g' apprtc/out/app_engine/apprtc.py
sed -i 's/https:\/\//http:\/\//g' apprtc/out/app_engine/apprtc.py
cp /apprtc_configs/constants.py /apprtc/out/app_engine/constants.py

$GOPATH/bin/collidermain -port=$COLLIDER_PORT -tls=$COLLIDER_STL --room-server=0.0.0.0 2>> /collider.log &
turnserver -L 0.0.0.0 -o -a -f -r apprtc
dev_appserver.py /apprtc/out/app_engine --skip_sdk_update_check --host=0.0.0.0
