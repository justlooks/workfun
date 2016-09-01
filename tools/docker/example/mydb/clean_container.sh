#!/bin/bash

for i in $(ls /var/lib/docker/containers);do
echo "remove $i"
docker rm $i
done
