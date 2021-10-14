FROM centos:centos8.4.2105
ARG GOPATH=/opt/app-root/src/go
ARG GO_WORKDIR=/opt/app-root/src/go/src/github.com/ibm-messaging/mq-container
ARG MQ_URL=http://buildmqnginx:80/9.2.0.3-IBM-MQ-Advanced-Non-Install-LinuxX86-64.tar.gz

LABEL summary="IBM MQ Advanced Server"
LABEL description="Simplify, accelerate and facilitate the reliable exchange of data with a security-rich messaging solution — trusted by the world’s most successful enterprises"
LABEL vendor="IBM"
LABEL maintainer="IBM"
LABEL distribution-scope="private"
LABEL authoritative-source-url="https://www.ibm.com/software/passportadvantage/"
LABEL url="https://www.ibm.com/products/mq/advanced"
LABEL io.openshift.tags="mq messaging"
LABEL io.k8s.display-name="IBM MQ Advanced Server"
LABEL io.k8s.description="Simplify, accelerate and facilitate the reliable exchange of data with a security-rich messaging solution — trusted by the world’s most successful enterprises"
LABEL base-image=$BASE_IMAGE
LABEL base-image-release=$BASE_TAG
RUN curl http://buildmqnginx/aux/runmqserver > /usr/local/bin/runmqserver
RUN curl http://buildmqnginx/aux/chkmqhealthy > /usr/local/bin/chkmqhealthy
RUN curl http://buildmqnginx/aux/chkmqready > /usr/local/bin/chkmqready
RUN curl http://buildmqnginx/aux/chkmqstarted > /usr/local/bin/chkmqstarted
COPY install-mq.sh /usr/local/bin/
COPY install-mq-server-prereqs.sh /usr/local/bin/
# Install MQ.  To avoid a "text file busy" error here, we sleep before installing.
RUN env
RUN mkdir /opt/mqm
RUN chmod u+x /usr/local/bin/install-*.sh
RUN sleep 1
RUN install-mq-server-prereqs.sh
RUN install-mq.sh
RUN /opt/mqm/bin/security/amqpamcf
RUN chown -R 1001:root /opt/mqm/*
# Create a directory for runtime data from runmqserver
RUN mkdir -p /run/runmqserver
RUN chown 1001:root /run/runmqserver
RUN curl http://buildmqnginx/aux/runmqserver > /usr/local/bin/runmqserver
RUN curl http://buildmqnginx/aux/chkmqhealthy > /usr/local/bin/chkmqhealthy
RUN curl http://buildmqnginx/aux/chkmqready > /usr/local/bin/chkmqready
RUN curl http://buildmqnginx/aux/chkmqstarted > /usr/local/bin/chkmqstarted
COPY NOTICES.txt /opt/mqm/licenses/notices-container.txt
COPY ha/native-ha.ini.tpl /etc/mqm/native-ha.ini.tpl
# Copy web XML files
COPY web /etc/mqm/web
COPY etc/mqm/*.tpl /etc/mqm/
RUN chmod ug+x /usr/local/bin/runmqserver
RUN chown 1001:root /usr/local/bin/*mq*
RUN chmod ug+x /usr/local/bin/chkmq*
RUN chown -R 1001:root /etc/mqm/*
RUN install --directory --mode 2775 --owner 1001 --group root /run/runmqserver
RUN touch /run/termination-log
RUN chown 1001:root /run/termination-log
RUN chmod 0660 /run/termination-log
RUN chmod -R g+w /etc/mqm/web
# Always use port 1414 for MQ & 9157 for the metrics
EXPOSE 1414 9157 9443
ENV MQ_OVERRIDE_DATA_PATH=/mnt/mqm/data MQ_OVERRIDE_INSTALLATION_NAME=Installation1 MQ_USER_NAME="mqm" PATH="${PATH}:/opt/mqm/bin"
ENV MQ_GRACE_PERIOD=30
ENV LANG=en_US.UTF-8 AMQ_DIAGNOSTIC_MSG_SEVERITY=1 AMQ_ADDITIONAL_JSON_LOG=1 LOG_FORMAT=basic
# We can run as any UID
USER 1001
ENV MQ_CONNAUTH_USE_HTP=false
ENTRYPOINT ["runmqserver"]
