#!/bin/bash

THREEWEEKSAGO="$(date -Ins --date="3 Weeks Ago")"
#NOW="$(date)"
NOW="$(date --date="2017-06-12T07:11:40.909671Z")"


docker images -q | while read IMAGE_ID; do
    IMAGE_DATE = docker inspect --format='{{.Created}}' --type=image ${IMAGE_ID}
    if [ "$IMAGE_DATE" < "$THREEWEEKSAGO" ]; then
	    docker rmi -f $IMAGE_ID
    fi
done

