#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo '[!] Usage: scan.sh [docker_image_id]'
    exit 0
fi

if [ -z ${SCANNER_IP} ]; then
  export SCANNER_IP=$(docker run --rm --network="docker_scan" kammin/clair_scanner:0.3 hostname -i)
fi

if [ -z ${CLAIR_IP} ]; then
  export CLAIR_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' clair_clair)
fi

test -d clair_reports || mkdir -p clair_reports

for image in $@
do
  image_name=$(docker image inspect -f '{{json .RepoTags}}' $image | awk -F'"' '$0=$2' |  tr /: _)
  echo "[!] scanning $image_name"
  docker run --rm --network="docker_scan" -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/clair_reports:/reports \
  kammin/clair_scanner:0.3 /bin/bash -c "clair-scanner --ip ${SCANNER_IP} --clair="http://${CLAIR_IP}:6060" --report="/reports/$image_name-output.json" $image"
done
