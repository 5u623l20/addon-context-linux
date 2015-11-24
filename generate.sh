#!/bin/bash

# -------------------------------------------------------------------------- #
# Copyright 2010-2014, C12G Labs S.L.                                        #
#                                                                            #
# Licensed under the Apache License, Version 2.0 (the "License"); you may    #
# not use this file except in compliance with the License. You may obtain    #
# a copy of the License at                                                   #
#                                                                            #
# http://www.apache.org/licenses/LICENSE-2.0                                 #
#                                                                            #
# Unless required by applicable law or agreed to in writing, software        #
# distributed under the License is distributed on an "AS IS" BASIS,          #
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
# See the License for the specific language governing permissions and        #
# limitations under the License.                                             #
#--------------------------------------------------------------------------- #

VERSION=${VERSION:-4.14.2}
MAINTAINER=${MAINTAINER:-OpenNebula Systems <support@opennebula.systems>}
LICENSE=${LICENSE:-Apache 2.0}
PACKAGE_NAME=${PACKAGE_NAME:-one-context}
VENDOR=${VENDOR:-OpenNebula Systems}
DESC="
This package prepares a VM image for OpenNebula:
  * Adds OpenNebula contextualization scripts to startup
    * Set root authorized keys (from SSH_PUBLIC_KEY and EC2_PUBLIC_KEY)
  * Add onegate tool (NEEDS RUBY AND JSON GEM TO WORK)
  * Generate host ssh keys in debian distributions

To get support check the OpenNebula web page:
  http://OpenNebula.org
"
DESCRIPTION=${DESCRIPTION:-$DESC}
PACKAGE_TYPE=${PACKAGE_TYPE:-deb}
URL=${URL:-http://opennebula.org}

[ $PACKAGE_TYPE = rpm ] && PKGARGS="--rpm-os linux"

SCRIPTS_DIR=$PWD
NAME="${PACKAGE_NAME}_${VERSION}.${PACKAGE_TYPE}"
rm $NAME

rm -rf tmp
mkdir tmp
cp -r base/* tmp
cp -r base_$PACKAGE_TYPE/* tmp

for i in $*; do
  cp -r "$i" tmp
done

cd tmp

fpm -n "$PACKAGE_NAME" -t "$PACKAGE_TYPE" $PKGARGS -s dir --vendor "$VENDOR" \
    --license "$LICENSE" --description "$DESCRIPTION" --url "$URL" \
    -m "$MAINTAINER" -v "$VERSION" --after-install $SCRIPTS_DIR/postinstall \
    -a all -p $SCRIPTS_DIR/$NAME *

echo $NAME


