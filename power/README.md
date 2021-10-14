# download
mkdir downloads

mkdir downloads/aux

cp 9.2.0.3-IBM-MQ-Advanced-Non-Install-LinuxPPC64LE.tar.gz ./downloads

# Cambiar configuracion del docker desktop
dockere engine > "buildkit": false

# crear centos tool
docker build -t cysce/centostool:8.4.2105 --file /home/cocdata/mq-container/power/centostool/Dockerfile .

# Crear NGINX para publicacion de archivos

docker network create buildmq

DOWNLOAD_FOLDER=/home/cocdata/mq-container/downloads

docker run --rm --name cysce/buildmqnginx:1.0.0 --network buildmq --network-alias buildmqnginx --volume $DOWNLOAD_FOLDER:/usr/share/nginx/html:ro --detach docker.io/nginx nginx -g "daemon off;"

# Crear imagen temporal builder y copiar archivos finales
docker build --network buildmq --tag cysce/buildermq:1.0.0 --file /home/cocdata/mq-container/power/builder/Dockerfile .

docker run --rm --name buildermqaux --network buildmq --volume $DOWNLOAD_FOLDER/aux:/usr/aux --detach cysce/buildermq:1.0.0 /usr/sbin/init

docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/runmqserver /usr/aux
docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/chkmqhealthy /usr/aux
docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/chkmqready /usr/aux
docker exec buildermqaux cp /opt/app-root/src/go/src/github.com/ibm-messaging/mq-container/chkmqstarted /usr/aux

docker stop buildermqaux
docker rm buildermqaux

# Crear images final mqserver
docker build --network buildmq --tag docker.io/cysce/mqserver:9.2.0.3 --file /home/cocdata/mq-container/power/mqserver/Dockerfile .

# Crear una instancia de mqserver
docker run \
  --name mqserver01 \
  --env LICENSE=accept \
  --env MQ_QMGR_NAME=QM1 \
  --publish 1414:1414 \
  --publish 9443:9443 \
  --detach \
  docker.io/cysce/mqserver:9.2.0.3

