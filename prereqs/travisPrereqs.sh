#!/bin/bash
#
# Prereq build script wrapper for Travis CI server which makes use of
# caching. This used by the .travis.yml configuration.
#

SOURCE_DIR=$1/prereqs
PREREQ_DIR=$2
SCRIPT=buildPrereqs.sh
PWD=${PWD}

md5sum ${SOURCE_DIR}/${SCRIPT} 
md5sum ${PREREQ_DIR}/${SCRIPT}

# Check if buildPrereqs.sh has changed (otherwise use the cached version)
if ! cmp ${PREREQ_DIR}/${SCRIPT} ${SOURCE_DIR}/${SCRIPT} >/dev/null 2>&1
then
  echo "Prereq cache out-of-date. Rebuilding stateline dependencies"
  cd ${PREREQ_DIR}
  cp ${SOURCE_DIR}/${SCRIPT} ${PREREQ_DIR}/${SCRIPT} 
  sh ./${SCRIPT}
  cd ${PWD}
else
  echo "buildPrereqs.sh has not changed. Using cached dependendies"
fi


