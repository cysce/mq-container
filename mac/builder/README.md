docker build --network buildmq --tag buildermq:1.0.0 --file /Volumes/DATA/CYSCE/BROKER/mq-container/mac/builder/Dockerfile .




docker run --name buildermq -id centostool:centos8.4.2105
docker exec -it buildermq /bin/bash



