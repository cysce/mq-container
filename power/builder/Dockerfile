FROM cysce/centostool:8.4.2105

ARG GOPATH=/opt/app-root/src/go
ARG GO_WORKDIR=/opt/app-root/src/go/src/github.com/ibm-messaging/mq-container
ARG MQ_URL=http://buildmqnginx/9.2.0.3-IBM-MQ-Advanced-Non-Install-LinuxPPC64LE.tar.gz
USER 0
COPY install-mq.sh /usr/local/bin/
RUN mkdir /opt/mqm
RUN chmod a+x /usr/local/bin/install-mq.sh
RUN sleep 1
RUN INSTALL_SDK=1 install-mq.sh
RUN chown -R 1001:root /opt/mqm/*
WORKDIR $GO_WORKDIR/
COPY cmd/ ./cmd
COPY internal/ ./internal
COPY pkg/ ./pkg
COPY vendor/ ./vendor
ENV CGO_CFLAGS="-I/opt/mqm/inc/" \
    CGO_LDFLAGS_ALLOW="-Wl,-rpath.*"
ENV PATH="${PATH}:/opt/mqm/bin"
RUN go build -ldflags "-X \"main.ImageCreated=$(date --iso-8601=seconds)\" -X \"main.ImageRevision=$IMAGE_REVISION\" -X \"main.ImageSource=$IMAGE_SOURCE\" -X \"main.ImageTag=$IMAGE_TAG\"" ./cmd/runmqserver/
RUN go build ./cmd/chkmqready/
RUN go build ./cmd/chkmqhealthy/
RUN go build ./cmd/chkmqstarted/
RUN go build ./cmd/runmqdevserver/
RUN go test -v ./cmd/runmqdevserver/...
RUN go test -v ./cmd/runmqserver/
RUN go test -v ./cmd/chkmqready/
RUN go test -v ./cmd/chkmqhealthy/
RUN go test -v ./cmd/chkmqstarted/
RUN go test -v ./pkg/...
RUN go test -v ./internal/...
RUN go vet ./cmd/... ./internal/...