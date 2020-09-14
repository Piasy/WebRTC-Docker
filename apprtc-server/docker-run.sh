ip=`hostname -i`

docker run --rm --net=host -e PUBLIC_IP=`hostname -i` -it webrtc