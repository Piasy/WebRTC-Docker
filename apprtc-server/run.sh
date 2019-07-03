sed -i 's/wss:\/\//ws:\/\//g' /apprtc/out/app_engine/apprtc.py
sed -i 's/https:\/\//http:\/\//g' /apprtc/out/app_engine/apprtc.py

sed -i "s/SERVER_PUBLIC_IP/${PUBLIC_IP}/g" /apprtc/out/app_engine/constants.py
sed -i "s/ROOM_SIZE_VALUE/${ROOM_SIZE_VALUE}/g" /apprtc/out/app_engine/constants.py
sed -i "s/AUTO_DESTROY_SIZE_VALUE/${AUTO_DESTROY_SIZE_VALUE}/g" /apprtc/out/app_engine/constants.py

supervisord -c /apprtc_supervisord.conf
