#!/bin/bash
#
# Push the latest puddle to the mirrors
#
############
# VARIABLES
############
TYPE="${1}"
VERSION="${2}"
BASEDIR="/mnt/rcm-guest/puddles/RHAOS"

if [ "${TYPE}" == "simple" ] ; then
PUDDLEDIR="${BASEDIR}/AtomicOpenShift/${VERSION}/latest/"
LASTDIR=`ls -lh ${BASEDIR}/AtomicOpenShift/${VERSION}/latest | awk '{print $11}'`
else
PUDDLEDIR="${BASEDIR}/AtomicOpenShift-errata/${VERSION}/latest/"
LASTDIR=`ls -lh ${BASEDIR}/AtomicOpenShift-errata/${VERSION}/latest | awk '{print $11}'`
fi
echo $LASTDIR

ssh -l jenkins_aos_cd_bot -o StrictHostKeychecking=no use-mirror-upload.ops.rhcloud.com "cd /srv/enterprise/enterprise-${VERSION} ; cp -r --link latest/ $LASTDIR ; rm -f latest ; ln -s $LASTDIR latest"
rsync -aHv --delete-after --progress --no-g --omit-dir-times --chmod=Dug=rwX -e "ssh -l jenkins_aos_cd_bot -o StrictHostKeyChecking=no" ${PUDDLEDIR} use-mirror-upload.ops.rhcloud.com:/srv/enterprise/enterprise-${VERSION}/latest/
if [ "${TYPE}" == "simple" ] ; then
ssh -l jenkins_aos_cd_bot -o StrictHostKeychecking=no use-mirror-upload.ops.rhcloud.com "cd /srv/enterprise/enterprise-${VERSION}/latest ; ln -s mash/rhaos-${VERSION}-rhel-7-candidate RH7-RHAOS-${VERSION}"
fi
ssh -l jenkins_aos_cd_bot -o StrictHostKeychecking=no use-mirror-upload.ops.rhcloud.com /usr/local/bin/push.enterprise.sh enterprise-${VERSION} -v
