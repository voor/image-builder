# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:focal

ENV PACKER_ARGS ''
ENV PACKER_VAR_FILES ''

RUN apt-get update && apt-get install -y apt-transport-https ca-certificates ansible curl wget git rsync vim jq unzip build-essential \
    && useradd -ms /bin/bash ansible \
    && curl -sL https://releases.hashicorp.com/packer/1.6.0/packer_1.6.0_linux_amd64.zip -o /tmp/packer.zip && unzip /tmp/packer.zip && mv packer /usr/local/bin/packer \
    && rm -rf /tmp/packer.zip \
    && apt-get purge --auto-remove -y \
    && rm -rf /var/lib/apt/lists/*

COPY . /home/ansible

USER ansible
WORKDIR /home/ansible/

RUN make deps

ENTRYPOINT [ "/home/ansible/hack/container-entrypoint.sh" ]
