
FROM docker.io/centos:8.4.2105

ARG EXTRA_RPMS="bash bc ca-certificates file findutils gawk glibc-common grep ncurses-compat-libs passwd procps-ng sed shadow-utils tar util-linux which"
WORKDIR /
RUN yum install -y go
RUN yum install -y golang
RUN yum -y install --setopt install_weak_deps=false $EXTRA_RPMS

CMD ["/usr/sbin/init"]