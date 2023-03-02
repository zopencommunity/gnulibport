#!/bin/sh
#
# Script run to do a custom install
#

devdir="${PWD}"
installdir="${ZOPEN_INSTALL_DIR}"

echo "My Dir: ${devdir} Dev Dir: ${installdir}"

if [ "${installdir}x" = "x" ]; then
  echo "ZOPEN_INSTALL_DIR needs to be set to run this script"
  exit 4
fi

rm -rf "${installdir}/"
mkdir -p "${installdir}"
/bin/cp -rpf "${devdir}/"  "${installdir}/"

exit 0
