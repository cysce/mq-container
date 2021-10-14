#!/bin/bash
# -*- mode: sh -*-
# © Copyright IBM Corporation 2015, 2021
#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo '************ Start install mq-server-prereqs.sh ************'

# Fail on any non-zero return code
set -ex

test -f /usr/bin/yum && YUM=true || YUM=false
test -f /usr/bin/microdnf && MICRODNF=true || MICRODNF=false
test -f /usr/bin/rpm && RPM=true || RPM=false

if ($RPM); then
  EXTRA_RPMS="bash bc ca-certificates file findutils gawk glibc-common grep ncurses-compat-libs passwd procps-ng sed shadow-utils tar util-linux which"
  # Install additional packages required by MQ, this install process and the runtime scripts
  yum install -y golang
  $YUM && yum -y install --setopt install_weak_deps=false ${EXTRA_RPMS}
  $MICRODNF && microdnf --disableplugin=subscription-manager install ${EXTRA_RPMS}
fi

# Clean up cached files
$YUM && yum -y clean all
$YUM && rm -rf /var/cache/yum/*
# $MICRODNF && microdnf --disableplugin=subscription-manager clean all
