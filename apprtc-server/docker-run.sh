#!/bin/bash
ip=`hostname -i`

if [ "$1" != "" ] ; then
	ip=$1
fi

#docker run --rm --net=host -e PUBLIC_IP=`hostname -i` -it webrtc
docker run --rm --net=host -e PUBLIC_IP=$ip -it webrtc