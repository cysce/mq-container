docker network create buildmq

DOWNLOAD_FOLDER=/Volumes/DATA/CYSCE/BROKER/mq-container/downloads

docker run --rm --name buildmqnginx --network buildmq --network-alias buildmqnginx --volume $DOWNLOAD_FOLDER:/usr/share/nginx/html:ro --detach nginx:1.21.3 nginx -g "daemon off;"

docker build --network buildmq --tag buildermq:1.0.0 --file /Volumes/DATA/CYSCE/BROKER/mq-container/mac/builder/Dockerfile .

docker run --rm --name buildermqaux --network buildmq --volume $DOWNLOAD_FOLDER/aux:/usr/aux --detach buildermq:1.0.0 /usr/sbin/init

docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/runmqserver /usr/aux
docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/chkmqhealthy /usr/aux
docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/chkmqready /usr/aux
docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/chkmqstarted /usr/aux

docker stop buildermqaux
docker rm buildermqaux

docker build --network buildmq --tag mqserver:1.0.0 --file /Volumes/DATA/CYSCE/BROKER/mq-container/mac/mqserver/Dockerfile .


docker run \
  --name mqserver01 \
  --env LICENSE=accept \
  --env MQ_QMGR_NAME=QM1 \
  --publish 1414:1414 \
  --publish 9443:9443 \
  --detach \
  mqserver:1.0.0

