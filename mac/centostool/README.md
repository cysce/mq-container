docker build -t centostool:centos8.4.2105 .



EXTRA_RPMS="bash bc ca-certificates file findutils gawk glibc-common grep ncurses-compat-libs passwd procps-ng sed shadow-utils tar util-linux which"
  # Install additional packages required by MQ, this install process and the runtime scripts
  yum install -y golang
  $YUM && yum -y install --setopt install_weak_deps=false ${EXTRA_RPMS}
  $MICRODNF && microdnf --disableplugin=subscription-manager install ${EXTRA_RPMS}

  