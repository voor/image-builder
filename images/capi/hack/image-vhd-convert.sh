#!/bin/bash

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

################################################################################
# usage: image-vhd-convert.sh BUILD_DIR RAWDISK VHDDISK
#  This program uses qemu raw output to convert to vhd with fixed size
#   for use in Azure
#  Source: https://docs.microsoft.com/en-us/azure/virtual-machines/
#           linux/create-upload-generic#resizing-vhds
################################################################################

set -o errexit
set -o nounset
set -o pipefail

if [ "${#}" -lt "3" ]; then
  echo "usage: ${0} BUILD_DIR RAWDISK VHDDISK" 1>&2
  exit 1
fi

BUILD_DIR=$1
RAWDISK=$2
VHDDISK=$3

MB=$((1024*1024))
size=$(qemu-img info -f raw --output json "${BUILD_DIR}/$RAWDISK" | \
    gawk 'match($0, /"virtual-size": ([0-9]+),/, val) {print val[1]}')

ROUNDED_SIZE=$(((($size+$MB-1)/$MB)*$MB))

echo "Rounded Size = ${ROUNDED_SIZE}"

qemu-img resize -f raw ${BUILD_DIR}/${RAWDISK} ${ROUNDED_SIZE}
qemu-img convert -f raw -o subformat=fixed,force_size \
    -O vpc ${BUILD_DIR}/${RAWDISK} ${BUILD_DIR}/${VHDDISK}